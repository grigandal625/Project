class CreateFbresults < ActiveRecord::Migration
  def change
    create_table :fbresults do |t|
      t.text :group
      t.string :fio
      t.string :fb
      t.integer :result

      t.timestamps
    end
  end
end
