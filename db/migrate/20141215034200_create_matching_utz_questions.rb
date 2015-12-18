class CreateMatchingUtzQuestions < ActiveRecord::Migration
  def change
    create_table :matching_utz_questions do |t|
      t.text :text
      t.references :matching_utz

      t.timestamps null: false
    end
  end
end
