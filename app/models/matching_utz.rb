class MatchingUtz < ActiveRecord::Base
  has_many :matching_utz_questions, dependent: :destroy
  belongs_to :ka_topic

  def questions
    matching_utz_questions
  end

  def answers
    MatchingUtzAnswer.where matching_utz_question_id: matching_utz_questions.ids
  end

  def self.label
    return "расстановка соответствий между блоками"
  end

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    super(options)
  end
end
