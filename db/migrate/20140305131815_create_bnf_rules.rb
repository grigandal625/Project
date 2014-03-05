class CreateBnfRules < ActiveRecord::Migration
  def change
    create_table :bnf_rules do |t|
      t.text :left
      t.text :right
      t.references :bnf, index: true

      t.timestamps
    end
  end
end
