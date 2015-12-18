class CreateTestUtzAnswers < ActiveRecord::Migration
  def change
    create_table :test_utz_answers do |t|
      t.text :text
      t.boolean :is_correct
      t.references :test_utz_question, index: true

      t.timestamps null: false
    end
    #add_foreign_key :test_utz_answers, :test_utz_question_ids
  end
end
