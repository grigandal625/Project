class RenameActionsToOntologyRules < ActiveRecord::Migration[5.0]
  def change
    rename_column :ontology_rules, :action, :actions
  end
end
