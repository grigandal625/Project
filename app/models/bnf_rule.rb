class BnfRule < ActiveRecord::Base
  belongs_to :bnf

  def compare_rules(rule)
    errors = 0
    rule.right.split('|').each do |subrule|
      errors += 1 unless right.include?(subrule)
    end
    right.split('|').each do |subrule|
      errors += 1 unless rule.right.include?(subrule)
    end
    return errors
  end
end
