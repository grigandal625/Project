#coding: utf-8
class GAnswer < ActiveRecord::Base
  belongs_to :task
  Not_name = ["C", "Н", "ВС", "П"]
  
  def generate_task(groups)
    task = []
    for sentence_id in ["0", "1", "2"]
      sentence = ""
      groups.each do |key, group|
        if group["sentence"] == sentence_id
          sentence += group["data"] + " "
        end
      end
      task << sentence
    end
    return task
  end
  
  def check_answer(answer_to_check)
    log = []
    mistakes = []
    for i in 0..10
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
        mistakes[10] += 1
        log << "Слово #{group["data"]} не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    generate_task(standard_groups).each do |sentence|
      sentence.split(" ").each do |word|
        flag = false
        standard_groups.each do |st_group|
          words = st_group["data"].split(" ")
          word.each do |pret_word|
            #TODO проверка того, что всё происходит в одном предложении
            if ( ( word == pret_word ) )
              #найдена группа, в составе которой находится текущее слово
              groups_to_check.each do |ch_group|
                ch_words = ch_group["data"].split(" ")
                ch_words.each do |ch_word|
                  if ( ( word == ch_word ) )
                    #найдена группа в ответе студента с тем же словом
                    if ( st_group["groupName"] not in Not_name ) &&
                      ( ch_group["groupName"] not in Not_name )
                      #сравнить 2 именные группы пословно, изменить флаг
                    else
                      if st_group["groupName"] == ch_group["groupName"]
                      #сравнить группы пословно, изменить флаг
                      end
                    end
                end
              end
            end
          end
        end
        if !flag
          #выставить ошибку
        end
      end
    end
    #TODO проверка наличия описания лишних групп, двух предикатов
    #TODO проверка БНФ для G
    puts mistakes
    return 100
  end
  
end
