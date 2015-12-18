class CreateConstructs < ActiveRecord::Migration
  def change
    create_table :constructs do |t|
      t.string :name, null: false, default: ""

      t.timestamps
    end
  end
end
