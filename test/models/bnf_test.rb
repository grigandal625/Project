require 'test_helper'

class BnfTest < ActiveSupport::TestCase
  test "check init" do
    rules = [{"left" => "lolka", "right" => "lal"},
             {"left" => nil, "right" => "wrong"}]
    result = VResult.new
    result.create_bnf
    result.bnf.init_bnf(rules)
    assert true
  end
end
