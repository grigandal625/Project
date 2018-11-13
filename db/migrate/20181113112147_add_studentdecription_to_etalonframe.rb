class AddStudentdecriptionToEtalonframe < ActiveRecord::Migration[5.0]
  def change
    add_column :etalonframes, :stdecription, :text
  end
end
