class CreateFillingUtzAnswers < ActiveRecord::Migration
  def change
    create_table :filling_utz_answers do |t|
      t.string :text
      t.references :filling_utz_interval, index: true

      t.timestamps null: false
    end
    #add_foreign_key :filling_utz_answers, :filling_utz_intervals
  end
end
