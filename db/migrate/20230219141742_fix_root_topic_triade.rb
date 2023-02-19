class FixRootTopicTriade < ActiveRecord::Migration[5.0]
  def change
    remove_column :triades, :root_topic
  end
end
