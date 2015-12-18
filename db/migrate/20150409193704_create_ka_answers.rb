class CreateKaAnswers < ActiveRecord::Migration
  def change
    create_table :ka_answers do |t|
      t.text :text,              null: false, default: ""
      t.integer :correct,        null: false, default: 0
      t.references :ka_question, index: true

      t.timestamps
    end
  end
end
