class MatchingUtzAnswer < ActiveRecord::Base
  belongs_to :matching_utz_question

  def question
    matching_utz_question
  end
end
