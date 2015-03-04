class CreateStudentframes < ActiveRecord::Migration
  def change
    create_table :studentframes do |t|
      t.references :etalonframe, index: true
      t.references :student, index: true
      t.text :studentcode
      t.integer :result
      t.text  :result
      t.boolean :isfinish

      t.timestamps
    end
  end
end
