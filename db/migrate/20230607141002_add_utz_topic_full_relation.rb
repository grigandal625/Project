class AddUtzTopicFullRelation < ActiveRecord::Migration[5.0]
  def change
    add_reference :test_utz_topics, :matching_utz
    add_reference :test_utz_topics, :filling_utz
    add_reference :test_utz_topics, :text_correction_utz
    add_reference :test_utz_topics, :images_sort_utz
    add_reference :test_utz_topics, :likert_utz
    add_reference :test_utz_topics, :hierarchy_utz
  end
end
