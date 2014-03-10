require 'test_helper'

class BnfTest < ActiveSupport::TestCase
  test "check init" do
    rules = [{"left" => "lolka", "right" => "lal"},
             {"left" => nil, "right" => "wrong"}]
    result = VResult.new
    result.create_bnf
    result.bnf.init_result_bnf(rules)
    p result.bnf.bnf_rules.inspect
    assert true
  end
end
