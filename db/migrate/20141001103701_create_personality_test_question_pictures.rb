class CreatePersonalityTestQuestionPictures < ActiveRecord::Migration
  def change
    create_table :personality_test_question_pictures do |t|
      t.string :image_uid
      t.references :personality_test_question
      t.timestamps
    end

  #TODO: add index
  end
end
