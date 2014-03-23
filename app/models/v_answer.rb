#coding: utf-8

class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component, dependent: :destroy

  Bnf_elements_to_check =
    {'<словарная статья понятий>' =>
      ["кодификатор части речи", "род", "число", "падеж", "одушевленность"],
     '<словарная статья предикатов>' =>
      ["вид", "время", "МУ"],
     '<словарная статья вопросительных слов>' =>
      ["кодификатор части речи", "семантический признак"],
     '<словарная статья характеристик>' =>
      ["кодификатор части речи", "род", "число", "падеж"],
     '<словарная статья предлогов>' =>
      ["кодификатор части речи"],
     '<словарная статья неизменяемых словоформ>' =>
      ["кодификатор части речи"],
     '<актант>' =>
      ["имя семантической валентности"]}

  def set_rules(bnf_hash)
    bnf_hash.each do |left, right|
      right.delete("0")
      rule = bnf.bnf_rules.where(left: left).first
      if rule != nil
        rule.right = right.join('|')
      else
        rule = bnf.bnf_rules.create(left: left, right: right.join('|'))
      end
      rule.save
    end
  end

  def check_answer(bnf_to_check)
    errors = {1 => 0, 2 => 8, 3 => 2, 4 => 5, 5 => 0, 6 => 0, 7 => 1, 8 => 1, 9 => 1, 10 => 1}
    log = ""
    for rule in bnf_to_check.bnf_rules
      case rule.left
      when '<имя словаря>'
        errors[4] -= 1
        log << "Найдено описание <имя словаря>\n"
        if rule.right.split('|').length > 6
          errors[2] += 1
          log << "Указаны лишние элементы в <имя словаря>\n"
        end
        V_name_list.each do |vname|
          unless rule.right.include?(vname)
            errors[1] += 1
            log << "Не указано имя словаря: #{vname}\n"
          end
        end
      when '<словарная статья>'
        errors[4] -= 1
        log << "Найдено описание <словарная статья>\n"
        if rule.right.split('|').length != 6
          errors[2] += 1
          log << "Указаны лишние элементы в <словарная статья>\n"
        end
      when '<словарная статья понятий>'
        check_standard_bnf_rule(rule, log, errors)
        errors[9] -= 1
      when '<словарная статья предикатов>'
        check_standard_bnf_rule(rule, log, errors)
        errors[10] -= 1
      when '<словарная статья вопросительных слов>'
        check_standard_bnf_rule(rule, log, errors)
        errors[4] -= 1
      when '<словарная статья характеристик>'
        check_standard_bnf_rule(rule, log, errors)
        errors[8] -= 1
      when '<словарная статья предлогов>'
        check_standard_bnf_rule(rule, log, errors)
        errors[4] -= 1
      when '<словарная статья неизменяемых словоформ>'
        check_standard_bnf_rule(rule, log, errors)
        errors[4] -= 1
      when '<МУ>'
        errors[7] -= 1
        log << "Найдено описание <МУ>\n"
      when '<актант>'
        unless rule.right.include?("имя семантической валентности")
          errors[5] += 1
        log << "Для #{rule.left} не указано: <имя семантической валентности>\n"
        end
      when '<род>', '<число>', '<одушевленность>', '<вид>', '<время>',
        '<предлог>', '<семантический признак>', '<кодификатор части речи>'
        errors[2] -= 1
        errors[1] += ( wrong = bnf.bnf_rules.find_by(left: rule.left).compare_rules(rule))
        log << "#{rule.left}: #{wrong} ошибок в описании\n"
      when '<падеж>', '<имя семантической валентности>'
        errors[2] += ( wrong = bnf.bnf_rules.find_by(left: rule.left).compare_rules(rule))
        log << "#{rule.left}: #{wrong} ошибок в описании\n"
        errors[3] -= 1
      end
    end
    #puts errors.inspect
    mark = 100
    errors.each {|type, val| mark -= Cost[type]*val }
    #puts log
    return mark > 0 ? mark : 0, log
  end

  private
  def check_standard_bnf_rule(rule, log, errors)
    log << "Найдено описание #{rule.left}\n"
    Bnf_elements_to_check[rule.left].each do |element|
      unless rule.right.include?(element)
        errors[3] += 1
        log << "Для #{rule.left} не указано: <#{element}>\n"
      end
    end
  end

end
