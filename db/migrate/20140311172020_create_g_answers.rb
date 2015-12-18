class CreateGAnswers < ActiveRecord::Migration
  def change
    create_table :g_answers do |t|
      t.text :answer
      t.references :task, index: true
    end
  end
end
