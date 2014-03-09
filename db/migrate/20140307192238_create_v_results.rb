class CreateVResults < ActiveRecord::Migration
  def change
    create_table :v_results do |t|
      t.integer :mark
      t.references :task, index: true
      t.references :student, index: true

      t.timestamps
    end
  end
end
