class CreateImagesSortUtzs < ActiveRecord::Migration
  def change
    create_table :images_sort_utzs do |t|
      t.text :goal
      t.text :theme
      t.string :hint
      t.integer :level

      t.timestamps null: false
    end
  end
end
