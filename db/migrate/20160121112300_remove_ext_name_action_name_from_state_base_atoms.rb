class RemoveExtNameActionNameFromStateBaseAtoms < ActiveRecord::Migration
  def change
    remove_column :state_base_atoms, :ext_name
    remove_column :state_base_atoms, :action_name
  end
end
