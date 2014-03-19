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
  
  def clear_bnf(bnf)
    #TODO добавить поле статуса
    bnf.each do |line|
      if line != nil && line["left"] != nil
        line["left"].gsub! '&lt;', ''
        line["left"].gsub! '&gt;', ''
        if line["right"] != nil
          line["right"].each do |word|
            word.gsub! '&lt;', ''
            word.gsub! '&gt;', ''
          end
        end
      end
    end
    return bnf
  end
  
  def check_answer(answer_to_check)
    log = []
    mistakes = []
    for i in 0..10
      mistakes << 0
    end
    t_answer = JSON.parse(answer_to_check)
    groups_to_check = t_answer["groups"]
    bnf_to_check = clear_bnf(t_answer["bnf"])
    standard_answer = JSON.parse(answer)
    standard_groups = standard_answer["groups"]
    standard_bnf = clear_bnf(standard_answer["bnf"])
    puts bnf_to_check.inspect
    #Слово не принадлежащее групе - ошибка типа 10
    groups_to_check.each do |key, group|
      if group["type"] != "group"
        #ошибка типа 6
        mistakes[6] += 1
        log << "Слово \"#{group["data"]}\" не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    sen_id = -1;
    generate_task(standard_groups).each do |sentence|
      sen_id += 1
      sentence.split(" ").each do |word|
        #флаг будет истинным, если слово в ответе и вопросе в разных категориях групп
        #т.е. в именной и нет
        flag = false
        gr_flag = ""
        cnt_mist = -1
        standard_groups.each do |key, st_group|
          words = st_group["data"].split(" ")
          words.each do |pret_word|
            #TODO проверка того, что всё происходит в одном предложении
            if ( ( word == pret_word ) && ( sen_id.to_s == st_group["sentence"] ) )
              #найдена группа, в составе которой находится текущее слово
              if pret_word["type"] != "group"
                w_mistakes = 1
                gr_flag = "Слово"
                flag = true
              else
                groups_to_check.each do |key, ch_group|
                  ch_words = ch_group["data"].split(" ")
                  ch_words.each do |ch_word|
                    if ( ( word == ch_word ) && ( sen_id.to_s == ch_group["sentence"] ) )
                      #найдена группа в ответе студента с тем же словом
                      if ( ( !Not_name.include?(st_group["groupName"]) &&
                        ( !Not_name.include?(ch_group["groupName"]) ) ) ||
                        st_group["groupName"] == ch_group["groupName"] )
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
                        if w_mistakes == 0
                          #нашли 2 одинаковые группы по вхождению слов
                          #оценим бнф описание
                          bnf_flag = false
                          bnf_correct = false
                          standard_bnf.each do |st_line|
                            if st_line != nil && st_line["left"] == st_group["groupName"]
                              #нашли нужную строку в эталоне
                              bnf_to_check.each do |ch_line|
                              if ch_line != nil && ch_line["left"] == ch_group["groupName"]
                                #нашли нужную строку в ответе студента
                                #проставить ей статус
                                bnf_flag = true
                                if st_line["right"].eql?(ch_line["right"])
                                  bnf_correct = true
                                end
                                #если не корректна накинуть ошибку
                              end
                            end
                          end
                        end
                        if cnt_mist == -1
                          cnt_mist = w_mistakes
                          gr_flag = st_group["groupName"]
                        else
                          if cnt_mist > w_mistakes
                            cnt_mist = w_mistakes
                            gr_flag = st_group["groupName"]
                          end
                        end#сравнить соответствующие БНФ (В конце)
                      end
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
          #WTF?
          mistakes[6] += 1
          #TODO исправить текст лога
          log << "Слово \"#{word}\" отнесено ИГ, а должно быть наоборот"
        else
          if Not_name.include?(gr_flag)
            #выставить ошибку описания неименной группы
            if gr_flag == "П"
              if cnt_mist != 0
                mistakes[3] += 1
                log << "Слово \"#{word}\" отнесено к предикату, но он отличается от эталонного"
              end
            else
              if cnt_mist != 0
                mistakes[1] += 1
                log << "Слово \"#{word}\" отнесено к С,ВС или Н, но группа отличается от эталонной"
              end
            end
          else
            if gr_flag != "Слово"
              #выставить ошибку описания именной группы
              if cnt_mist !=0
                mistakes[2] += 1
                log << "Слово \"#{word}\" отнесено к ИГ, но она отличается от эталонной"
              end
            end
          end
        end
      end
    end
    #проверить наличие двух предикатов
    for sentence_id in ["0", "1", "2"]
      pred_num = 0
      groups_to_check.each do |key, ch_group|
        if ch_group["groupName"] == "П" && ch_group["sentence"] == sentence_id
          pred_num += 1
        end
      end
      if pred_num > 1
        mistakes[7] += 1
        case sentence_id
        when "0"
          log << "Обнаружено наличие более 1 предиката в предложении 1"
        when "1"
          log << "Обнаружено наличие более 1 предиката в предложении 2"
        when "2"
          log << "Обнаружено наличие более 1 предиката в предложении 3"
        end
      end
    end
    #TODO проверка БНФ для G
    puts log
    puts mistakes
    mark = 100
    for id in 0..10
      mark -= mistakes[id]*Cost[id]
    end
    if mark < 0
      mark = 0
    end
    puts "mark " + mark.to_s
    return mark, mistakes.to_s, log
  end
  
end
