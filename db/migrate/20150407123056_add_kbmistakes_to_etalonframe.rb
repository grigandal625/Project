class AddKbmistakesToEtalonframe < ActiveRecord::Migration
  def change
    add_column :etalonframes, :kbmistakes, :text
  end
end
