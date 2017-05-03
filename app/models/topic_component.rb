class TopicComponent < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :component
end
