class AddMistakesToEtalonframes < ActiveRecord::Migration
  def change
    add_column :etalonframes, :mistakes, :text
  end
end
