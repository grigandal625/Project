#coding: utf-8

class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component, dependent: :destroy, autosave: true

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
    bnf_rules = JSON.parse(bnf.bnf_json || "{}")
    bnf_hash.each do |left, right|
      right.delete("0")
      bnf_rules[left] = right.join('|')
    end
    bnf.bnf_json = bnf_rules.to_json
  end

  def check_answer(bnf_to_check)
    errors = {1 => 0, 2 => 8, 3 => 2, 4 => 5, 5 => 0, 6 => 0, 7 => 1, 8 => 1, 9 => 1, 10 => 1}
    log = ""
    bnf_rules = JSON.parse(bnf_to_check.bnf_json)
    ans_rules = JSON.parse(bnf.bnf_json)
    bnf_rules.each do |left, right|
      case left
      when '<имя словаря>'
        errors[4] -= 1
        log << "Найдено описание <имя словаря>\n"
        if right.split('|').length > 6
          errors[2] += 1
          log << "Указаны лишние элементы в <имя словаря>\n"
        end
        V_name_list.each do |vname|
          unless right.include?(vname)
            errors[1] += 1
            log << "Не указано имя словаря: #{vname}\n"
          end
        end
      when '<словарная статья>'
        errors[4] -= 1
        log << "Найдено описание <словарная статья>\n"
        if right.split('|').length != 6
          errors[2] += 1
          log << "Указаны лишние элементы в <словарная статья>\n"
        end
      when '<словарная статья понятий>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[9] -= 1
      when '<словарная статья предикатов>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[10] -= 1
      when '<словарная статья вопросительных слов>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[4] -= 1
      when '<словарная статья характеристик>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[8] -= 1
      when '<словарная статья предлогов>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[4] -= 1
      when '<словарная статья неизменяемых словоформ>'
        check_standard_bnf_rule(left, right, log, errors)
        errors[4] -= 1
      when '<МУ>'
        errors[7] -= 1
        log << "Найдено описание <МУ>\n"
      when '<актант>'
        unless right.include?("имя семантической валентности")
          errors[5] += 1
        log << "Для #{left} не указано: <имя семантической валентности>\n"
        end
      when '<род>', '<число>', '<одушевленность>', '<вид>', '<время>',
        '<предлог>', '<семантический признак>', '<кодификатор части речи>'
        errors[2] -= 1
        errors[1] += ( wrong = compare_rules(right, ans_rules[left]))
        log << "#{left}: #{wrong} ошибок в описании\n"
      when '<падеж>', '<имя семантической валентности>'
        errors[2] += ( wrong = compare_rules(right, ans_rules[left]))
        log << "#{left}: #{wrong} ошибок в описании\n"
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
  def check_standard_bnf_rule(left, right, log, errors)
    log << "Найдено описание #{left}\n"
    Bnf_elements_to_check[left].each do |element|
      unless right.include?(element)
        errors[3] += 1
        log << "Для #{left} не указано: <#{element}>\n"
      end
    end
  end

  def compare_rules(right, right_ans)
    err = 0
    right.split('|').each do |elem|
      err += 1 unless right_ans.include?(elem)
    end
    right_ans.split('|').each do |elem|
      err += 1 unless right.include?(elem)
    end
    return err
  end

end
