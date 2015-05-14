class TopicRelation < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :related_topic, class_name: "KaTopic"
end
