class CreatePersonalityTestAnswerPictures < ActiveRecord::Migration
  def change
    create_table :personality_test_answer_pictures do |t|
      t.string :image_uid
      t.references :personality_test_answer

      t.timestamps
    end
  end

  #TODO: add index
end
