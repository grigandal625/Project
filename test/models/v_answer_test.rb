require 'test_helper'

class VAnswerTest < ActiveSupport::TestCase
  test "empty" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:test1v)
    ans = testAnswer.check_answer(testBnf).first
    puts "Result mark is #{ans}"
    assert ans == 0
  end

  test "right" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:test2v)
    ans = testAnswer.check_answer(testBnf).first
    puts "Result mark is #{ans}"
    assert ans == 100
  end

  test "without predicate" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:test3v)
    ans = testAnswer.check_answer(testBnf).first
    puts "Result mark is #{ans}"
    assert ans == 59
  end

  test "without MU" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:test4v)
    ans = testAnswer.check_answer(testBnf).first
    puts "Result mark is #{ans}"
    assert ans == 80
  end

  test "without predicate and nouns" do
    testAnswer = v_answers(:first)
    testBnf = bnfs(:test5v)
    ans = testAnswer.check_answer(testBnf).first
    puts "Result mark is #{ans}"
    assert ans == 41
  end
end
