class LikertUtzRenameRef < ActiveRecord::Migration[5.0]
  def change
    rename_column :likert_utzs, :ka_topics_id, :ka_topic_id
  end
end
