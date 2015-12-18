class CreateTestUtzQuestions < ActiveRecord::Migration
  def change
    create_table :test_utz_questions do |t|
      t.text :text

      t.timestamps null: false
    end
  end
end
