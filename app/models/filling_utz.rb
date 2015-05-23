class FillingUtz < ActiveRecord::Base
  has_many :filling_utz_intervals, dependent: :destroy

  def intervals
    filling_utz_intervals
  end
end
