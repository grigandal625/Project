class AddRecStatusToRecomendations < ActiveRecord::Migration[5.0]
  def change
    add_column :recomendations, :rec_status, :string
  end
end
