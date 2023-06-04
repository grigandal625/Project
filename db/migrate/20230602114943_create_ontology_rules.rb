class CreateOntologyRules < ActiveRecord::Migration[5.0]
  def change
    create_table :ontology_rules do |t|
      t.text :condition
      t.text :action

      t.timestamps
    end
  end
end
