class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title
      t.integer :tip_id
      t.text :description

      t.timestamps
    end
  end
end
