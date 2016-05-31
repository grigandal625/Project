class CreateStateBaseAtoms < ActiveRecord::Migration
  def change
    create_table :state_base_atoms do |t|
      t.string :type
      t.integer :state
      t.string :ext_name
      t.string :action_name
      t.string :task_name
      t.references :planning_state, index: true

      t.timestamps
    end
  end
end
