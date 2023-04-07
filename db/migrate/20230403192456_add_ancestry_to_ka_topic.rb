class AddAncestryToKaTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :ka_topics, :ancestry, :string
    add_index :ka_topics, :ancestry
  end
end
