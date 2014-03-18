#coding: utf-8

class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component

  def set_rules(bnf_hash)
    bnf_hash.each do |left, right|
      rule = bnf.bnf_rules.where(left: left).first
      puts rule.inspect
      if rule != nil
        rule.right = right.join('|')
      else
        rule = bnf.bnf_rules.create(left: left, right: right.join('|'))
      end
      rule.save
    end
  end

  def check_answer(bnf_to_check) #TODO write algorithm
    errors = {1 => 0, 2 => 8, 3 => 2, 4 => 5, 5 => 0, 6 => 0, 7 => 1, 8 => 1, 9 => 1, 10 => 1}
    for rule in bnf_to_check.bnf_rules
      case rule.left
      when '<имя словаря>'
        errors[4] -= 1
        errors[2] += 1 if rule.right.split('|').length > 6
        V_name_list.each{ |vname| errors[1] += 1 unless rule.right.include?(vname) }
      when '<словарная статья>'
        errors[4] -= 1
        errors[2] += 1 if rule.right.split('|').length != 6
      when '<словарная статья понятий>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[3] += 1 unless rule.right.include?("род")
        errors[3] += 1 unless rule.right.include?("число")
        errors[3] += 1 unless rule.right.include?("падеж")
        errors[3] += 1 unless rule.right.include?("одушевленность")
        errors[9] -= 1
      when '<словарная статья предикатов>'
        errors[3] += 1 unless rule.right.include?("вид")
        errors[3] += 1 unless rule.right.include?("время")
        errors[9] += 1 unless rule.right.include?("МУ")
        errors[10] -= 1
      when '<словарная статья вопросительных слов>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[2] += 1 unless rule.right.include?("семантический признак")
        errors[4] -= 1
      when '<словарная статья характеристик>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[3] += 1 unless rule.right.include?("род")
        errors[3] += 1 unless rule.right.include?("число")
        errors[3] += 1 unless rule.right.include?("падеж")
        errors[8] -= 1
      when '<словарная статья предлогов>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[4] -= 1
      when '<словарная статья неизменяемых словоформ>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[4] -= 1
      when '<МУ>'
        errors[7] -= 1
      when '<актант>'
        errors[5] += 1 unless rule.right.include?("имя семантической валентности")
      when '<род>', '<число>', '<одушевленность>', '<вид>', '<время>',
        '<предлог>', '<семантический признак>', '<кодификатор части речи>'
        errors[1] += bnf.bnf_rules.find_by(left: rule.left).compare_rules(rule)
        errors[2] -= 1
      when '<падеж>', '<имя семантической валентности>'
        errors[2] += bnf.bnf_rules.find_by(left: rule.left).compare_rules(rule)
        errors[3] -= 1
      end
    end
    #puts errors.inspect
    mark = 100
    errors.each {|type, val| mark -= Cost[type]*val }
    #puts "you have mark #{mark}"
    return mark
  end

end
