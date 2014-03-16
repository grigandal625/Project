#coding: utf-8
class GAnswer < ActiveRecord::Base
  belongs_to :task
  @low_cost = ["C", "Н", "ВС"]
  @not_name = ["C", "Н", "ВС", "П"]
  
  def generate_task(groups)
    task = []
    for sentence_id in ["0", "1", "2"]
      sentence = ""
      groups.each do |key, group|
        if group["sentence"] == sentence_id
          sentence += group["data"]
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
    bnf_to_check = t_answer["bnf"]
    standard_answer = JSON.parse(answer)
    standard_groups = standard_answer["groups"]
    standard_bnf = standard_answer["bnf"]
    #Проверка правильности описания, по отсутствию лишних слов
    
    #Слово не принадлежащее групе - ошибка типа 10
    groups_to_check.each do |key, group|
      group["status"] = "0"
      if group["type"] != "group"
        mistakes[9] += 1
        log << "Слово #{group["data"]} не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    task = generate_task(standard_groups)
    #TODO проверка наличия описания лишних групп
    #TODO проверка БНФ для G
    return 100
  end
  
end
