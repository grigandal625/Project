class PersonalityTestQuestion < ActiveRecord::Base
  belongs_to  :personality_test
  belongs_to  :personality_test_question_type
  has_many    :personality_test_answers, dependent: :destroy
  has_one     :personality_test_question_picture, dependent: :destroy
  default_scope {order(ordering: :asc)}

  accepts_nested_attributes_for :personality_test_answers

  def test
    personality_test
  end

  def type
    personality_test_question_type
  end

  def answers
    personality_test_answers
  end

  def picture
    personality_test_question_picture
  end
end
