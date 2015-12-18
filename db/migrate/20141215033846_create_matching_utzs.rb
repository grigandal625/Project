class CreateMatchingUtzs < ActiveRecord::Migration
  def change
    create_table :matching_utzs do |t|
      t.string :name
      t.text :hint
      t.integer :level

      t.timestamps null: false
    end
  end
end
