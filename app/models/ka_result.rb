class KaResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :ka_variant
  belongs_to :ka_test
  has_many   :ka_answer_logs
end
