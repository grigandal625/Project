class CreateKaTopics < ActiveRecord::Migration
  def change
    create_table :ka_topics do |t|
      t.string  :text,     null: false, default: ""
      t.integer :parent_id

      t.timestamps
    end

    add_index :ka_topics, :parent_id
  end
end
