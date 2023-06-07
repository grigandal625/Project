class FillingUtz < ActiveRecord::Base
  has_many :filling_utz_intervals, dependent: :destroy
  belongs_to :ka_topic
  has_many :filling_utz_elements, dependent: :destroy

  def intervals
    filling_utz_intervals
  end

  def elements
    filling_utz_elements
  end

  def self.label
    return "заполнение пропусков в тексте"
  end
end
