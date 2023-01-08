class CreateLikertUtzs < ActiveRecord::Migration[5.0]
  def change
    create_table :likert_utzs do |t|
      t.string :text

      t.timestamps
    end
  end
end
