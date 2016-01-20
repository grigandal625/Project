class AddOntologyToKaTopics < ActiveRecord::Migration
  def change
    add_column :ka_topics, :ontology, :boolean
  end
end
