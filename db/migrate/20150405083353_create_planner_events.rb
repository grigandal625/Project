class CreatePlannerEvents < ActiveRecord::Migration
  def change
    create_table :planner_events do |t|
        t.references :user
        t.integer :type_id #0 - plan generated, 1-session started, 2-session ended, 3-task started, 4-task ended
        t.string :description
        t.timestamps
    end
  end
end
