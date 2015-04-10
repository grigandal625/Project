class CreateKaVariants < ActiveRecord::Migration
  def change
    create_table :ka_variants do |t|
      t.references :ka_test
      t.integer    :number,   null: false

      t.timestamps
    end

    add_index :ka_variants, [:ka_test_id, :number]
  end
end
