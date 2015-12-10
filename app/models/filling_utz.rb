class FillingUtz < ActiveRecord::Base
  has_many :filling_utz_intervals, dependent: :destroy
  belongs_to :ka_topic

  def intervals
    filling_utz_intervals
  end
end
