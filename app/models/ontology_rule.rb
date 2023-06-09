require "json"
include ::Tools::OntologyRulesTools::Rules

class OntologyRule < ApplicationRecord
  def rule
    cond = symbolize_keys(JSON.parse(self.condition))
    acts = symbolize_keys(JSON.parse(self.actions))
    return ::Tools::OntologyRulesTools::Rules::Rule.from_hash({
             condition: cond,
             actions: acts,
           })
  end

  private

  def symbolize_keys(hash)
    hash.each_with_object({}) do |(k, v), h|
      new_key = k.is_a?(String) ? k.to_sym : k
      new_val = v.is_a?(Hash) ? symbolize_keys(v) : v
      h[new_key] = new_val
    end
  end

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    res = super(options)
    puts res
    res["actions"] = JSON.parse(res["actions"])
    res["condition"] = JSON.parse(res["condition"])
    return res
  end

  
end
