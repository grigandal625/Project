class Component < ActiveRecord::Base
 has_many :topic_components, dependent: :delete_all
 has_many :ka_topics, through: :topic_components
 has_many :component_service
end
