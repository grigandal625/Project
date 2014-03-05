class CreateVAnswers < ActiveRecord::Migration
  def change
    create_table :v_answers do |t|
      t.references :task, index: true

      t.timestamps
    end
  end
end
