#coding: utf-8
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
    for rule in bnf_to_check.bnf_rules
      case rule.left
      when '<имя словаря>'
        #TODO
      when '<словарная статья>'
        #TODO
      when '<словарная статья понятий>'
        #TODO
      when '<словарная статья предикатов>'
        #TODO
      when '<словарная статья вопросителmных слов>'
        #TODO
      when '<словарная статья характеристик>'
        #TODO
      when '<словарная статья предлогов>'
        #TODO
      when '<словарная статья неизменяемых словоформ>'
        #TODO
      end
    end
    return 100
  end

end
