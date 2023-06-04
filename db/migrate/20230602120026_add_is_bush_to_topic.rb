class AddIsBushToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :ka_topics, :is_bush_vertex, :boolean
  end
end
