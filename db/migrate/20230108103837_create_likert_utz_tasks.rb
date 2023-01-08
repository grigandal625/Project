class CreateLikertUtzTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :likert_utz_tasks do |t|
      t.string :text
      t.references :likert_utz, foreign_key: true

      t.timestamps
    end
  end
end
