class CreateSResults < ActiveRecord::Migration
  def change
    create_table :s_results do |t|
      t.references :result, index: true
      t.integer :mark
      t.text :answer

      t.timestamps
    end
  end
end
