class CreatePersonalities < ActiveRecord::Migration
  def change
    create_table :personalities do |t|
      t.string :name
      t.text :description
      t.references :personality_trait
      t.float :begin_at
      t.float :end_at

      t.timestamps
    end
  end
end
