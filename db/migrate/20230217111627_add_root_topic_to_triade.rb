class AddRootTopicToTriade < ActiveRecord::Migration[5.0]
  def change
    add_column :triades, :root_topic, :integer
    add_foreign_key :triades, :ka_topics, column: :root_topic
  end
end
