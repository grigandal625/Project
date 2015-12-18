class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :sentence1
      t.text :sentence2
      t.text :sentence3

    end
  end
end
