class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.text :fio
      t.references :group, index: true

    end
  end
end
