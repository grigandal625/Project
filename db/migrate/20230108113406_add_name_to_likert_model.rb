class AddNameToLikertModel < ActiveRecord::Migration[5.0]
  def change
    add_column :likert_utzs, :name, :string, default: ""
  end
end
