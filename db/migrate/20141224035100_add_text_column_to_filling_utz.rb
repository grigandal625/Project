class AddTextColumnToFillingUtz < ActiveRecord::Migration
  def change
    add_column :filling_utzs, :text, :text
  end
end
