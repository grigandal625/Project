class ProblemArea < ActiveRecord::Base
  belongs_to :ka_result
  belongs_to :ka_topic
end
