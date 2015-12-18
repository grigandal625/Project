class ChangePersonalityDefaultValues < ActiveRecord::Migration
  def change
    change_column_default :personalities, :begin_at, 0
    change_column_default :personalities, :end_at, 0
  end
end
