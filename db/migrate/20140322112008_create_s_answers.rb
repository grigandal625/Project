class CreateSAnswers < ActiveRecord::Migration
  def change
    create_table :s_answers do |t|
      t.references :task, index: true
      t.text :answer

      t.timestamps
    end
  end
end
