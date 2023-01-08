class ChangeFillingYtzAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :filling_utz_elements do |t|
      t.integer :number
      t.string :text
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
