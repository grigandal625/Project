class CreateTopicRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_relations, id: false do |t|
    t.references  :ka_topic,          index: true
    t.integer     :related_topic_id,  index: true
    t.integer     :rel_type, null: false, default: 2

    t.timestamps
  end
end
end
