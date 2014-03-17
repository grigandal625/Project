require 'test_helper'

class VAnswerTest < ActiveSupport::TestCase
  test "check answer" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:checkv)
    ans = testAnswer.check_answer(testBnf)
    puts "Result mark is #{ans}"
    assert ans == 100
  end

  test "check wrong answer" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:samplev)
    ans = testAnswer.check_answer(testBnf)
    puts "Result mark is #{ans}"
    assert ans
  end
end
