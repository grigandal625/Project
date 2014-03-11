class CreateVResults < ActiveRecord::Migration
  def change
    create_table :v_results do |t|
      t.references :result, index: true

      t.timestamps
    end
  end
end
