#coding: utf-8
class GAnswer < ActiveRecord::Base
  belongs_to :task
  @low_cost = ["C", "Н", "ВС"]
  @not_name = ["C", "Н", "ВС", "П"]
  
  def generate_task(groups)
    task = []
    for sentence_id in ["0", "1", "2"]
      sentence = ""
      for group_id in groups
        #logger.debug(group_id.inspect)
        if group_id[1]["sentence"] == sentence_id
          sentence += group_id[1]["data"]
        end
      end
      sentence = sentence.split(" ")
      task << sentence
    end
    return task
  end
  
  def check_answer(answer_to_check)
    log = []
    mistakes = []
    for i in 1..10
      mistakes << 0
    end
    t_answer = JSON.parse(answer_to_check)
    groups_to_check = t_answer["groups"]
    #logger.debug(groups_to_check.inspect)
    bnf_to_check = t_answer["bnf"]
    standard_answer = JSON.parse(answer)
    standard_groups = standard_answer["groups"]
    standard_bnf = standard_answer["bnf"]
    #Проверка правильности описания, по отсутствию лишних слов
    
    #Слово не принадлежащее групе - ошибка типа 10
    for group_id in groups_to_check
      #logger.debug(group_id.inspect)
      group_id[1]["status"] = "0"
      if group_id[1]["type"] != "group"
        mistakes[9] = mistakes[9] + 1
        log << "Слово #{groups_to_check[group_id].data} не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    task = generate_task(standard_groups)
    #TODO проверка наличия описания лишних групп
    #TODO проверка БНФ для G
    return 100
  end
  
end
