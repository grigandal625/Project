class TopicCompetence < ActiveRecord::Base
  belongs_to :competence
  belongs_to :ka_topic
end
