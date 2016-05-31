class KaQuestion < ActiveRecord::Base
  belongs_to :ka_topic
  has_many :ka_answer, dependent: :destroy
end
