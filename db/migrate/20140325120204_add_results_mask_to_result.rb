class AddResultsMaskToResult < ActiveRecord::Migration
  def change
    add_column :results, :results_mask, :integer
  end
end
