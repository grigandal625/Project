class AddOntologyIntToKaTopics < ActiveRecord::Migration
  def change
    add_column :ka_topics, :ontology, :integer
  end
end
