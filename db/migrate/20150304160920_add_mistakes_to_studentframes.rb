class AddMistakesToStudentframes < ActiveRecord::Migration
  def change
    add_column :studentframes, :mistakes, :text
  end
end
