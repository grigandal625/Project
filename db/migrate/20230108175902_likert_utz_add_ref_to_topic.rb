class LikertUtzAddRefToTopic < ActiveRecord::Migration[5.0]
  def change
    add_reference :likert_utzs, :ka_topics, foreign_key: true
  end
end
