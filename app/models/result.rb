class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :task
  has_one :v_result
  has_one :g_result
  has_one :s_result
end
