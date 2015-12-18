class CreateTopicConstructs < ActiveRecord::Migration
  def change
    create_table :topic_constructs, id: false do |t|
      t.references :ka_topic,   index: true
      t.references :construct,  index: true
      t.integer :mark,          null: false, default: 0

      t.timestamps
    end
  end
end
