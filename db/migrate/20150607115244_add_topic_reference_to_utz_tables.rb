class AddTopicReferenceToUtzTables < ActiveRecord::Migration
  def change
    add_reference :test_utz_questions, :ka_topic, index: true
    add_reference :matching_utzs, :ka_topic, index: true
    add_reference :filling_utzs, :ka_topic, index: true
    add_reference :text_correction_utzs, :ka_topic, index: true
    add_reference :images_sort_utzs, :ka_topic, index: true
  end
end
