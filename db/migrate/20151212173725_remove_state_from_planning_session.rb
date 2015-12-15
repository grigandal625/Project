class RemoveStateFromPlanningSession < ActiveRecord::Migration
  def change
    remove_column :planning_sessions, :state
  end
end
