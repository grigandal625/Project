class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.text :FIO
      t.references :group, index: true

      t.timestamps
    end
  end
end
