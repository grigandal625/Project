class CreateMatchingUtzAnswers < ActiveRecord::Migration
  def change
    create_table :matching_utz_answers do |t|
      t.text :text
      t.references :matching_utz_question

      t.timestamps null: false
    end
  end
end
