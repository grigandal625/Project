class RefixRootTopicTriade < ActiveRecord::Migration[5.0]
  def change
    add_reference :triades, :root_topic, index: true
    add_foreign_key :triades, :ka_topics, column: :root_topic
  end
end
