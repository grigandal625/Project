class Task < ActiveRecord::Base
  has_many :results
  has_one :v_answer, autosave: true
  has_one :g_answer, autosave: true
  has_one :s_answer, autosave: true

end
