class AddForeignKeyToFutzElements < ActiveRecord::Migration[5.0]
  def change
    add_reference :filling_utz_elements, :filling_utz, foreign_key: true
  end
end
