class AddDescriptionToOntologyRules < ActiveRecord::Migration[5.0]
  def change
    add_column :ontology_rules, :description, :string
  end
end
