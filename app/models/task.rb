class Task < ActiveRecord::Base
  has_many :results
  has_one :v_answer
  has_one :g_answer
  has_one :s_answer
end
