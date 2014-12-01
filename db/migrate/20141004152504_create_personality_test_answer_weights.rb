class CreatePersonalityTestAnswerWeights < ActiveRecord::Migration
  def change
    create_table :personality_test_answer_weights do |t|
      t.float :value
      #TODO add index
      t.references :personality_test_answer
      t.references :personality_trait, index: true

      t.timestamps
    end
  end
end
