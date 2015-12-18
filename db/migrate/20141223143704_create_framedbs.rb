class CreateFramedbs < ActiveRecord::Migration
  def change
    create_table :framedbs do |t|
      t.text :code
      t.string :name

      t.timestamps
    end
  end
end
