class FillingUtzInterval < ActiveRecord::Base
  has_many :filling_utz_answers, dependent: :destroy
  belongs_to :filling_utz

  def answers
    filling_utz_answers
  end
end
