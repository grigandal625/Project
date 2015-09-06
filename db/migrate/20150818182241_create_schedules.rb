class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
    	t.integer :duration
    	t.string :data, null: false, default: "{}"
      	t.timestamps
    end
  end
end
