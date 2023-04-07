class CreateHierarchyUtzs < ActiveRecord::Migration[5.0]
  def change
    create_table :hierarchy_utzs do |t|
      t.string :text
      t.integer :weight
      t.string :data

      t.timestamps
    end
  end
end
