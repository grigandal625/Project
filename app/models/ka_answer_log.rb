class KaAnswerLog < ActiveRecord::Base
  belongs_to :ka_result
  belongs_to :ka_answer
end
