class CreatePersonalityTestQuestionTypes < ActiveRecord::Migration
  def change
    create_table :personality_test_question_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
