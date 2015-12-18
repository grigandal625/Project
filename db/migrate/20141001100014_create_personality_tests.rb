class CreatePersonalityTests < ActiveRecord::Migration
  def change
    create_table :personality_tests do |t|
      t.string :name
      #TODO add index
      t.references :personality_test_type
      t.timestamps
    end
  end
end
