class CreateEtalons < ActiveRecord::Migration
  def change
    create_table :etalons do |t|
      t.string :name
      t.text :etalonjson
      t.text :nodejson
      

      t.timestamps
    end
  end
end
