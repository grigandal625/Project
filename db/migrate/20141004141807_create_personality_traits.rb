class CreatePersonalityTraits < ActiveRecord::Migration
  def change
    create_table :personality_traits do |t|
      t.string :name

      t.timestamps
    end
  end
end
