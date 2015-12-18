class CreateKaTests < ActiveRecord::Migration
  def change
    create_table :ka_tests do |t|
      t.text    :text,            null: false
      t.integer :on,              null: false, default: 0
      t.integer :variants_count,  null: false, default: 0
      t.integer :questions_count, null: false, default: 0
      t.integer :minutes,         null: false, default: 0

      t.timestamps
    end
  end
end
