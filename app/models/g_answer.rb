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
      if group["type"] != "group"
        #ошибка типа 6 в связи с тем, что будет накинут штраф за неправильную группу
        mistakes[6] += 1
        log << "Слово #{group["data"]} не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    generate_task(standard_groups).each do |sentence|
      sentence.split(" ").each do |word|
        #флаг будет истинным, если слово в ответе и вопросе в разных категориях групп
        #т.е. в именной и нет
        flag = false
        gr_flag = ""
        cnt_mist = -1
        standard_groups.each do |key, st_group|
          puts st_group["data"]
          words = st_group["data"].split(" ")
          words.each do |pret_word|
            #TODO проверка того, что всё происходит в одном предложении
            if ( ( word == pret_word ) )
              #найдена группа, в составе которой находится текущее слово
              groups_to_check.each do |key, ch_group|
                ch_words = ch_group["data"].split(" ")
                ch_words.each do |ch_word|
                  if ( ( word == ch_word ) )
                    #найдена группа в ответе студента с тем же словом
                    if ( !Not_name.include?(st_group["groupName"])  ) &&
                      ( !Not_name.include?(ch_group["groupName"]) ) ||
                      st_group["groupName"] == ch_group["groupName"]
                      flag = true
                      #сравнить группы пословно, изменить флаг
                      w_mistakes = 0
                      #ищем невыделенные слова
                      st_group["data"].split(" ").each do |st_wrd|
                        flg = false
                        ch_group["data"].split(" ").each do |ch_wrd|
                          if st_wrd == ch_wrd
                            flg = true
                          end
                        end
                        if !flg
                          w_mistakes += 1
                        end
                      end
                      #ищем лишние слова
                      ch_group["data"].split(" ").each do |ch_wrd|
                        flg = false
                        st_group["data"].split(" ").each do |st_wrd|
                          if st_wrd == ch_wrd
                            flg = true
                          end
                        end
                        if !flg
                          w_mistakes += 1
                        end
                      end
                      #найдено количество слов, на которое отличаются группы
                      #если есть 2 таких слова, то ошибка будет взята по меньшему количеству слов
                      #возможно сделать на меньшую цену?
                      if cnt_mist == -1
                        cnt_mist = w_mistakes
                        gr_flag = st_group["groupName"]
                      else
                        if cnt_mist > w_mistakes
                          cnt_mist = w_mistakes
                          gr_flag = st_group["groupName"]
                        end
                      end
                      #сравнить соответствующие БНФ (В конце)
                    end
                  end
                end
              end
            end
          end
        end
        #выставить ошибку
        #Если была найдена хотя бы одна группа 1в1 равная нашей, то пускай ошибки нет
        #Если для любой потенциальной группы есть ошибка хотя бы в одно слово, то ошибка ценой 1 слова
        if !flag
          mistakes[6] += 1
        else
          if Not_name.include?(gr_flag)
            #выставить ошибку описания неименной группы
            if gr_flag == "П"
              if cnt_mist != 0
                mistakes[3] += 1
              end
            else
              if cnt_mist != 0
                mistakes[2] += 1
              end
            end
          else
            #выставить ошибку описания именной группы
            if cnt_mist !=0
              mistakes[1] += 1
            end
          end
        end
      end
    end
    #проверить наличие двух предикатов
    pred_num = 0
    standard_groups.each do |key, st_group|
      if st_group["GrouName"] == "П"
        pred_num += 1
      end
    end
    if pred_num > 1
      mistakes[7] += 1
    end
    #TODO проверка БНФ для G
    puts mistakes
    return 100
  end
  
end
