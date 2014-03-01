class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :variant
      t.text :sentence1
      t.text :sentence2
      t.text :sentence3

      t.timestamps
    end
    add_index :tasks, :variant, unique: true
  end
end
