class CreateKaAnswerLogs < ActiveRecord::Migration
  def change
    create_table :ka_answer_logs do |t|
      t.references :ka_result
      t.references :ka_answer

      t.timestamps
    end
  end
end
