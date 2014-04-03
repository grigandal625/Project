class CreateSemanticnetworks < ActiveRecord::Migration
  def change
    create_table :semanticnetworks do |t|
      t.references :etalon, index: true
      t.references :student, index: true
      t.text :json
      t.integer :rating

      t.timestamps
    end
  end
end
