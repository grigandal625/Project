class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :task
  has_one :v_result
  has_one :g_result
  has_one :s_result

  def mark
    #TODO change 100 to s_result.mark
    return (v_result.mark + g_result.mark + 100) / 3
  end
end
