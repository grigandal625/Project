class CreateKaQuestions < ActiveRecord::Migration
  def change
    create_table :ka_questions do |t|
      t.text :text,           null: false, default: ""
      t.integer :difficulty,  null: false, default: 0
      t.references :ka_topic, index: true

      t.timestamps
    end
  end
end
