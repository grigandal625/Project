class HierarchyUtz < ApplicationRecord
  belongs_to :ka_topic

  def name
    return self.text
  end

  def self.label
    return "построение иерархической структуры"
  end
end
