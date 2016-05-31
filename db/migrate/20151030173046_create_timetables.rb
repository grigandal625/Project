class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.references :group, index: true

      t.timestamps
    end
  end
end
