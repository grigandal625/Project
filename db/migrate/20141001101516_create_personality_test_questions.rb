class CreatePersonalityTestQuestions < ActiveRecord::Migration
  def change
    create_table :personality_test_questions do |t|
      t.text :value
      #TODO add index
      t.references :personality_test_question_type
      t.references :personality_test, index: true

      t.timestamps
    end
  end
end
