require 'test_helper'

class VAnswerTest < ActiveSupport::TestCase
  test "check answer" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:checkv)
    ans = testAnswer.check_answer(testBnf)
    puts "Result mark is #{ans}"
    assert ans == 1
  end
end
