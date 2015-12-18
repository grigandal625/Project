class CreateGResults < ActiveRecord::Migration
  def change
    create_table :g_results do |t|
      t.references :result, index: true
      t.text :answer
      t.integer :mark
    end
  end
end
