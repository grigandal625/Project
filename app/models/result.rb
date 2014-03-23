class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :task
  has_one :v_result, autosave: true
  has_one :g_result, autosave: true
  has_one :s_result, autosave: true

  def mark
    (v_result.mark + g_result.mark + s_result.mark) / 3
  end
end
