class Triade < ApplicationRecord
  belongs_to :first_topic, class_name: "KaTopic"
  belongs_to :second_topic, class_name: "KaTopic"
  belongs_to :third_topic, class_name: "KaTopic"
  belongs_to :root_topic, class_name: "KaTopic"
  belongs_to :constructs
end
