class PersonalityTestAnswerWeight < ActiveRecord::Base
  belongs_to :personality_test_answer
  belongs_to :personality_trait

  def answer
    personality_test_answer
  end

  def trait
    personality_trait
  end
end
