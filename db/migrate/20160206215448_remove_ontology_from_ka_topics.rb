class RemoveOntologyFromKaTopics < ActiveRecord::Migration
  def change
    remove_column :ka_topics, :ontology, :boolean
  end
end
