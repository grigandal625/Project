class CreateTopicComponents < ActiveRecord::Migration
  def change
    create_table :topic_components do |t|
      t.integer :ka_topic_id
      t.integer :component_id
    end
  end
end
