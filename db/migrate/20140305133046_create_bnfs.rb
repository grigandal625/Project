class CreateBnfs < ActiveRecord::Migration
  def change
    create_table :bnfs do |t|
      t.references :component, polymorphic: true, index: true

    end
  end
end
