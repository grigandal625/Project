class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :test_id
      t.integer :week
      t.references :timetable, index: true

      t.timestamps
    end
  end
end
