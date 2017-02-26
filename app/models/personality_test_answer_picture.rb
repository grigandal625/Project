class PersonalityTestAnswerPicture < ActiveRecord::Base
  belongs_to :personality_test_answer
  dragonfly_accessor :image

  def answer
    personality_test_answer
  end
end
