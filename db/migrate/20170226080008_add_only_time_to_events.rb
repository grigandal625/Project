class AddOnlyTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :only_time, :datetime
  end
end
