class CreateFramesmistakes < ActiveRecord::Migration
  def change
    create_table :framesmistakes do |t|
      t.text :mistakes

      t.timestamps
    end
  end
end
