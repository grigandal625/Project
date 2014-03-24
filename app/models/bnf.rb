class Bnf < ActiveRecord::Base
  belongs_to :component, polymorphic: true

  def self.init_bnf(v_answer_bnf)
    bnf_rules = {}
    for rule in v_answer_bnf
      bnf_rules[rule["left"]] = rule["right"]
    end
    bnf_rules.to_json
  end

end
