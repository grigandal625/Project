class CreateTriades < ActiveRecord::Migration[5.0]
  def change
    create_table :triades do |t|
      t.references :first_topic
      t.references :second_topic
      t.references :third_topic
      t.references :constructs, foreign_key: true
      t.boolean :accepted

      t.timestamps
    end
    add_foreign_key :triades, :ka_topics, column: :first_topic
    add_foreign_key :triades, :ka_topics, column: :second_topic
    add_foreign_key :triades, :ka_topics, column: :third_topic
  end
end
