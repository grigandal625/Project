class AddKaTopicIdToEtalons < ActiveRecord::Migration
  def change
    add_column :etalons, :ka_topic_id, :integer
  end
end
