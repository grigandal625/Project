class ChangeWeekType < ActiveRecord::Migration
  def change
    change_column :events, :week, :date
  end
end
