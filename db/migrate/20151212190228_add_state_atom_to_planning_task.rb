class AddStateAtomToPlanningTask < ActiveRecord::Migration
  def change
    add_reference :planning_tasks, :state_atom, index: true
  end
end
