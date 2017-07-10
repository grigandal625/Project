class CreateTopicComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_components do |t|
      t.references :ka_topic,   index: true
      t.references :component,  index: true

      t.timestamps
    end
  end
end
