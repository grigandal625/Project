class MatchingUtz < ActiveRecord::Base
  has_many :matching_utz_questions, dependent: :destroy

  def questions
    matching_utz_questions
  end

  def answers
    MatchingUtzAnswer.where matching_utz_question_id: matching_utz_questions.ids
  end
end
