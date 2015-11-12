class AddCheckToEtalons < ActiveRecord::Migration
  def change
    add_column :etalons, :check, :boolean
  end
end
