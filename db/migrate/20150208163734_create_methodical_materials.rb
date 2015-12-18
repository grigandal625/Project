class CreateMethodicalMaterials < ActiveRecord::Migration
  def change
    create_table :methodical_materials do |t|
      t.string :name
      t.string :title
      t.text :description
      t.text :theoretical_part
      t.text :practical_part

      t.timestamps
    end
  end
end
