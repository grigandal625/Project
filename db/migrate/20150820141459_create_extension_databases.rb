class CreateExtensionDatabases < ActiveRecord::Migration
  def change
    create_table :extension_databases do |t|

      t.timestamps
    end
  end
end
