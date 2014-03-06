require 'test_helper'

class VAnswerTest < ActiveSupport::TestCase
  test "check answer" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:checkv)
    ans = testAnswer.check_answer(testBnf)
    puts "Errors = #{ans}"
    assert ans
  end
end
