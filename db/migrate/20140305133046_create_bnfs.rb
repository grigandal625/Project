class CreateBnfs < ActiveRecord::Migration
  def change
    create_table :bnfs do |t|
      t.references :component, polymorphic: true, index: true

      t.timestamps
    end
  end
end
