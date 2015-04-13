class CreateKaResults < ActiveRecord::Migration
  def change
    create_table :ka_results do |t|
      t.references :ka_variant
      t.references :ka_test,  index: true
      t.references :user
      t.integer :assessment,  null: false

      t.timestamps
    end
  end
end
