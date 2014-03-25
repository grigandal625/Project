class Task < ActiveRecord::Base
  has_many :results
  has_one :v_answer, autosave: true, dependent: :destroy
  has_one :g_answer, autosave: true, dependent: :destroy
  has_one :s_answer, autosave: true, dependent: :destroy
end
