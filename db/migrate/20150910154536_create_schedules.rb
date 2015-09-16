class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :group
      t.integer :psyho
      t.integer :knowledge1
      t.integer :knowledge2
      t.integer :frame_sem
      t.integer :vivod

      t.timestamps
    end
  end
end
