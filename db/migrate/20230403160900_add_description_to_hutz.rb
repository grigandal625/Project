class AddDescriptionToHutz < ActiveRecord::Migration[5.0]
  def change
    add_column :hierarchy_utzs, :description, :string
  end
end
