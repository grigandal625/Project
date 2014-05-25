#coding: utf-8

class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component, dependent: :destroy, autosave: true

  Bnf_elements_to_check =
    {
      '<словарная статья понятий>' =>
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
      ["кодификатор части речи"]
  }

  Bnf_articles =
    {
      "словарь вопросительных слов" =>
        '<словарная статья вопросительных слов>',
      "словарь понятий" => '<словарная статья понятий>',
      "словарь неизменяемых словоформ" =>
        '<словарная статья неизменяемых словоформ>',
      "словарь предикатов" => '<словарная статья предикатов>',
      "словарь характеристик" => '<словарная статья характеристик>',
      "словарь предлогов" => '<словарная статья предлогов>'
  }

  Articles_error_types =
    {
     '<словарная статья понятий>' => 9,
     '<словарная статья предикатов>' => 10,
     '<словарная статья вопросительных слов>' => 4,
     '<словарная статья характеристик>' => 8,
     '<словарная статья предлогов>' => 4,
     '<словарная статья неизменяемых словоформ>' => 4
  }

  def set_rules(bnf_hash)
    bnf_rules = JSON.parse(bnf.bnf_json || "{}")
    bnf_hash.each do |left, right|
      right.delete("0")
      bnf_rules[left] = right.join('|')
    end
    bnf.bnf_json = bnf_rules.to_json
  end

  def check_answer(bnf_to_check)
    errors = {1 => 1, 2 => 8, 3 => 2, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0}
    log = ""
    bnf_rules = JSON.parse(bnf_to_check.bnf_json)
    ans_rules = JSON.parse(bnf.bnf_json)
    articles = {}
    ans_rules['<имя словаря>'].split('|').each do |vname|
      articles[Bnf_articles[vname]] = true
      errors[Articles_error_types[Bnf_articles[vname]]] += 1
    end
    bnf_rules.each do |left, right|
      log << "Найдено описание " + left + " ::= " + right + "\n"
      case left
      when '<словарная статья понятий>', '<словарная статья предикатов>',
        '<словарная статья вопросительных слов>',
        '<словарная статья характеристик>', '<словарная статья предлогов>',
          '<словарная статья неизменяемых словоформ>'
        check_standard_bnf_rule(left, right, log, errors)
        if articles[left] == true
          errors[Articles_error_types[left]] -= 1
        else
          errors[2] += 1
        end
      when '<МУ>'
        if articles['<словарная статья предикатов>'] == true
          errors[7] -= 1 if right.include?('актант')
        end
      when '<актант>'
        if articles['<словарная статья предикатов>'] == true
          errors[5] += 1 unless right.include?('имя семантической валентности')
        end
      when '<семантический компонент МУ>'
        if articles['<словарная статья предикатов>'] == true
          errors[3] += 1 unless right.include?('семантический признак')
        end
      when '<синтаксический компонент МУ>'
        if articles['<словарная статья предикатов>'] == true
          if right.include?('образец')
            errors[4] += 1
            articles['<образец>'] = true
          else
            errors[5] += 1
          end
        end
      when '<образец>'
        if articles['<образец>'] == true
          errors[4] -= 1
          errors[3] += 1 unless right.include?('падеж')
          errors[3] += 1 unless right.include?('предлог')
        end
      when '<род>', '<число>', '<одушевленность>', '<вид>', '<время>', '<лицо>',
        '<предлог>', '<кодификатор части речи>'
        errors[2] -= 1
        errors[1] += ( wrong = compare_rules(right, ans_rules[left]))
        log << "#{left}: #{wrong} ошибок в описании\n"
      when '<падеж>', '<имя семантической валентности>'
        errors[3] -= 1
        errors[2] += ( wrong = compare_rules(right, ans_rules[left]))
        log << "#{left}: #{wrong} ошибок в описании\n"
      when '<семантический признак>'
        errors[1] -= 1
        errors[1] += ( wrong = compare_rules(right, ans_rules[left]))
        log << "#{left}: #{wrong} ошибок в описании\n"
      when '<имя словаря>'
        errors[4] -= 1
        right.split('|').each do |vname|
          unless ans_rules[left].include?(vname)
            errors[1] += 1
            log << "Указан лишний элемент в #{left}: #{vname}\n"
          end
        end
        ans_rules[left].split('|').each do |vname|
          unless right.include?(vname)
            errors[1] += 1
            log << "Не указан словарь: #{vname}\n"
          end
        end
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
