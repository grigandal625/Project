class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :student, index: true
      t.references :task, index: true

      t.timestamps
    end
  end
end
