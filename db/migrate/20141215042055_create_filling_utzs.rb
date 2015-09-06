class CreateFillingUtzs < ActiveRecord::Migration
  def change
    create_table :filling_utzs do |t|
      t.string :name
      t.text :hint
      t.integer :level

      t.timestamps null: false
    end
  end
end
