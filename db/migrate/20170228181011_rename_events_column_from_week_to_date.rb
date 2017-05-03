class RenameEventsColumnFromWeekToDate < ActiveRecord::Migration
  def change
    rename_column :events, :week, :date
  end
end
