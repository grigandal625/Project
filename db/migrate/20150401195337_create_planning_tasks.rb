class CreatePlanningTasks < ActiveRecord::Migration
  def change
    create_table :planning_tasks do |t|
        t.references :planning_session
        t.integer :closed, :default => 0
        t.string :executor
        t.string :result
        t.string :action
        t.string :description
        t.timestamps
    end
  end
end
