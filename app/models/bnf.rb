class Bnf < ActiveRecord::Base
  belongs_to :component, polymorphic: true
  has_many :bnf_rules

  def init_bnf(v_answer_bnf)
    for rule in v_answer_bnf
      bnf_rules.create(left: rule["left"], right: rule["right"])
    end
  end

end
