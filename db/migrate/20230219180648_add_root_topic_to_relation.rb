class AddRootTopicToRelation < ActiveRecord::Migration[5.0]
  def change
    add_reference :topic_relations, :root_topic, index: true
    add_foreign_key :topic_relations, :ka_topics, column: :root_topic
  end
end
