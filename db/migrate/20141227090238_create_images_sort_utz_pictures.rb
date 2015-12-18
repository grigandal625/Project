class CreateImagesSortUtzPictures < ActiveRecord::Migration
  def change
    create_table :images_sort_utz_pictures do |t|
      t.text :src
      t.integer :ordering
      t.references :images_sort_utz, index: true

      t.timestamps null: false
    end
    #add_foreign_key :images_sort_utz_pictures, :images_sort_utzs
  end
end
