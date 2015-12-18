class CreateKaQuestionsVariants < ActiveRecord::Migration
  def change
    create_table :ka_questions_variants, id: false do |t|
      t.references :ka_variant
      t.references :ka_question

      t.timestamps
    end

    add_index :ka_questions_variants, [:ka_variant_id, :ka_question_id], name: 'ka_q_ka_v', unique: true
  end
end
