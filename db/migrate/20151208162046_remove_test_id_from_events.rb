class RemoveTestIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :test_id, :integer
  end
end
