class LikertUtz < ApplicationRecord
  belongs_to :ka_topic

  def self.label
    return "шкала Ликерта"
  end
end
