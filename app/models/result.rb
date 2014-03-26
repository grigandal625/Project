class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :task
  has_one :v_result, autosave: true
  has_one :g_result, autosave: true
  has_one :s_result, autosave: true

  def mark
    (v_result.mark + g_result.mark + s_result.mark) / 3
  end

  def has_g_result?
    (results_mask & 1) != 0
  end

  def has_v_result?
    (results_mask & 2) != 0
  end

  def has_s_result?
    (results_mask & 4) != 0
  end

end
