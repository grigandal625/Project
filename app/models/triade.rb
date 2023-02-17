class Triade < ApplicationRecord
  belongs_to :first_topic
  belongs_to :second_topic
  belongs_to :third_topic
  belongs_to :root_topic
end
