class GAnswer < ActiveRecord::Base
  belongs_to :task
  
  def check_answer(groups_to_check, bnf_to_check)
     obj_groups = JSON.parse(groups)
     obj_bnf = JSON.parse(bnf)
  end
  
end
