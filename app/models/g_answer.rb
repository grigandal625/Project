class GAnswer < ActiveRecord::Base
  belongs_to :task
  
  def check_answer(answer)
    answer = JSON.parse(answer)
    groups_to_check = answer["groups"]
    bnf_to_check = answer["bnf"]
    #TODO
    return 100
  end
  
end
