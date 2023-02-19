class AddSelectedThemeTriade < ActiveRecord::Migration[5.0]
  def change
    add_column :triades, :selected_theme, :integer
  end
end
