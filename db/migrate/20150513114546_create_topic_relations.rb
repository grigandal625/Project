class CreateTopicRelations < ActiveRecord::Migration
  def change
    create_table :topic_relations, id: false do |t|
      t.references  :ka_topic,          index: true
      t.integer     :related_topic_id,  index: true
      t.integer     :type, null: false, default: 2

      t.timestamps
    end
  end
end
