class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as: :component

  def check_answer(bnf_to_check)
    logger.debug "!!!! bnf_to_check = #{bnf_to_check.bnf_rules.inspect}"
    logger.debug "!!!! bnf = #{self.bnf.bnf_rules.inspect}"
    for rule in bnf_to_check.bnf_rules
      flag = false
      for check_rule in bnf.bnf_rules.where(left: rule.left)
        if rule.right == check_rule.right
          flag = true
          break
        end
      end
      if ! flag
        return false
      end
    end
    return true
  end

end
