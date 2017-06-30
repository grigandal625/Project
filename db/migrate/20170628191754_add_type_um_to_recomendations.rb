class AddTypeUmToRecomendations < ActiveRecord::Migration[5.0]
  def change
    add_column :recomendations, :type_um, :text
  end
end
