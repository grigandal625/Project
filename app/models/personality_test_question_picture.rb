class PersonalityTestQuestionPicture < ActiveRecord::Base
  dragonfly_accessor :image
  belongs_to :personality_test_question

  def question
    personality_test_question
  end
end
