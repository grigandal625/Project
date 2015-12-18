class AddKbstudentmistakesToStudentframe < ActiveRecord::Migration
  def change
    add_column :studentframes, :kbstudentmistakes, :text
  end
end
