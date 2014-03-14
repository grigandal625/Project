#coding: utf-8

include ActionView::Helpers::TasksHelper

class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component

  def compare_bnf(bnf_to_check) #temporary
    errors = 0
    for rule in bnf_to_check.bnf_rules
      flag = false
      for check_rule in bnf.bnf_rules.where(left: rule.left)
        if rule.right == check_rule.right
          flag = true; break
        end
      end
      errors += 1 unless flag
    end
    return errors
  end

  def check_answer(bnf_to_check) #TODO write algorithm
    errors = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 1, 9 => 1}
    for rule in bnf_to_check.bnf_rules
      case rule.left
      when '<имя словаря>'
        errors[2] += 1 if right = rule.right.split('|').length > 6
        V_name_list.each{ |vname| errors[1] += 1 unless rule.right.include?(vname) }
      when '<словарная статья>'
        errors[2] += 1 if right = rule.right.split('|').length > 6
      when '<словарная статья понятий>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[3] += 1 unless rule.right.include?("род")
        errors[3] += 1 unless rule.right.include?("число")
        errors[3] += 1 unless rule.right.include?("падеж")
        errors[3] += 1 unless rule.right.include?("одушевленность")
        errors[9] -= 1
      when '<словарная статья предикатов>'
        errors[1] += 1 unless rule.right.include?("кодификатор части речи")
        errors[2] += 1 unless rule.right.include?("семантический признак")
      when '<словарная статья вопросительных слов>'
        #TODO
      when '<словарная статья характеристик>'
        errors[3] += 1 unless rule.right.include?("кодификатор части речи")
        errors[3] += 1 unless rule.right.include?("род")
        errors[3] += 1 unless rule.right.include?("число")
        errors[3] += 1 unless rule.right.include?("падеж")
        errors[8] -= 1
      when '<словарная статья предлогов>'
        #TODO
      when '<словарная статья неизменяемых словоформ>'
        #TODO
      end
    end
    return 100
  end

end
