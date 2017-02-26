class CreateTimetableTemplates < ActiveRecord::Migration
  def change
    create_table :timetable_templates do |t|
      t.string :name
      t.text :json

      t.timestamps
    end
  end
end
