class CreateTopicCompetences < ActiveRecord::Migration
  def change
    create_table :topic_competences, id: false do |t|
      t.references :ka_topic,   index: true
      t.references :competence, index: true
      t.integer :weight,        null: false, default: 0

      t.timestamps
    end
  end
end
