class MatchingUtzQuestion < ActiveRecord::Base
  has_one :matching_utz_answer, dependent: :destroy
  belongs_to :matching_utz

  def answer
    matching_utz_answer
  end
end
