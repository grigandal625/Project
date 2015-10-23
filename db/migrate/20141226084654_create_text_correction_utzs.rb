class CreateTextCorrectionUtzs < ActiveRecord::Migration
  def change
    create_table :text_correction_utzs do |t|
      t.string :name
      t.text :text_with_errors
      t.text :text_without_errors
      t.integer :errors_count
      t.string :hint

      t.timestamps null: false
    end
  end
end
