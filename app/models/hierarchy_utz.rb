class HierarchyUtz < ApplicationRecord
    belongs_to :ka_topic

    def name
        return self.text
    end
end
