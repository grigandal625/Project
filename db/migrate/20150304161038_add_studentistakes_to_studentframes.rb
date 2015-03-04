class AddStudentistakesToStudentframes < ActiveRecord::Migration
  def change
    add_column :studentframes, :studentmistakes, :text
  end
end
