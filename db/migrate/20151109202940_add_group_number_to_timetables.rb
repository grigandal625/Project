class AddGroupNumberToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :group_number, :text
  end
end
