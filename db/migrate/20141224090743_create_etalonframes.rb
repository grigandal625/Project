class CreateEtalonframes < ActiveRecord::Migration
  def change
    create_table :etalonframes do |t|
      t.string :name
      t.text :dictionary
      t.text :studentcode
      t.text :framecode
      t.text :result

      t.timestamps
    end
  end
end
