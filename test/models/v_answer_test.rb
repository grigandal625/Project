require 'test_helper'

class VAnswerTest < ActiveSupport::TestCase
  test "check answer" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:checkv)
    assert testAnswer.check_answer(testBnf)
  end
end
