class AddIsuseToEtalonframe < ActiveRecord::Migration[5.0]
  def change
    add_column :etalonframes, :isuse, :boolean
  end
end
