class AddKaTopicIdToSemanticnetworks < ActiveRecord::Migration
  def change
    add_column :semanticnetworks, :ka_topic_id, :integer
  end
end
