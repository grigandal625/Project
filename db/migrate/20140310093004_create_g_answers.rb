class CreateGAnswers < ActiveRecord::Migration
  def change
    create_table :g_answers do |t|
      t.integer :variant
      t.text :groups
      t.text :bnf
      t.references :task, index: true

    end
  end
end
