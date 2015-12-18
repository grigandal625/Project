require 'test_helper'

class GAnswerTest < ActiveSupport::TestCase
  test "groups_bnf_st" do
    g_answers(:one).check_answer(g_results(:one).answer)
    assert true
  end
  test "groups_bnf_some_mistakes" do
    g_answers(:one).check_answer(g_results(:two).answer)
    assert true
  end
  test "second_task_levon_answer" do
    g_answers(:second).check_answer(g_results(:three).answer)
    assert true
  end
end
