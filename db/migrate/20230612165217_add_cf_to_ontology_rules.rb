class AddCfToOntologyRules < ActiveRecord::Migration[5.0]
  def change
    add_column :ontology_rules, :cf, :float
  end
end
