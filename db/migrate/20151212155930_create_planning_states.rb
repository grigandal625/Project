class CreatePlanningStates < ActiveRecord::Migration
  def change
    create_table :planning_states do |t|
      t.references :planning_session

      t.timestamps
    end
  end
end
