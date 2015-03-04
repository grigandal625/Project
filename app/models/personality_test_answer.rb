class PersonalityTestAnswer < ActiveRecord::Base
  belongs_to :personality_test_question
  has_one :personality_test_answer_picture
  has_many :personality_traits, through: :personality_test_answer_weights
  has_many :personality_test_answer_weights

  def question
    personality_test_question
  end

  def picture
    personality_test_answer_picture
  end

  def traits
    personality_traits
  end

  def weights
    personality_test_answer_weights
  end
end
