class CreateLikertUtzMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :likert_utz_matches do |t|
      t.references :likert_utz_task, foreign_key: true
      t.references :likert_utz_variant, foreign_key: true

      t.timestamps
    end
  end
end
