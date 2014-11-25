#coding: utf-8
class GAnswer < ActiveRecord::Base
  belongs_to :task
  Not_name = ["С", "Н", "ВС", "П"]
  Question = "Предложение типа вопрос"
  Order = "Предложение типа команда"
  Message = "Предложение типа сообщение"
  G = "G"

  def exist_pairs(first, second)
    in_first = {}
    in_second = {}
    num_f = 1
    first.each do |line_in_first|
      line_in_first.each do |blck|
        if blck[0..1] == 'ИГ'
          this_num = blck[3..-1]
          if in_first[this_num] == nil
            in_first[this_num] = num_f.to_s
            num_f += 1
          end
        end
      end
    end
    num_s = 1
    second.each do |line_in_second|
      line_in_second.each do |blck|
        if blck[0..1]== 'ИГ'
          this_num = blck[3..-1]
          if in_second[this_num] == nil
            in_second[this_num] = num_s.to_s
            num_s += 1
          end
        end
      end
    end

    for i in 0...first.length
      for j in 0...first[i].length
        if first[i][j][0..1] == 'ИГ'
          num = first[i][j][3..-1]
          first[i][j] = 'ИГ ' + in_first[num]
        end
      end
    end
    for i in 0...second.length
      for j in 0...second[i].length
        if second[i][j][0..1] == 'ИГ'
          num = second[i][j][3..-1]
          second[i][j] = 'ИГ ' + in_second[num]
        end
      end
    end

    cnt_errors = 0
    first.each do |line_in_first|
      line_flag = false
      second.each do |line_in_second|
        if line_in_first.to_s == line_in_second.to_s
          line_flag = true
        end
      end
      if (!line_flag)
        cnt_errors += 1
      end
    end
    second.each do |line_in_second|
      line_flag = false
      first.each do |line_in_first|
        if line_in_first.to_s == line_in_second.to_s
          line_flag = true
        end
      end
      if (!line_flag)
        cnt_errors += 1
      end
    end
    max_cnt = first.size
    if (cnt_errors > max_cnt)
      cnt_errors = max_cnt
    end
    return cnt_errors
  end

  def check_g_part(standard_bnf, bnf_to_check, left, log, mistakes)
    g_cnt = 0
    standard_bnf.each do |st_line|
      if st_line != nil && st_line["left"] == left
        st_line["status"] = 1
        bnf_to_check.each do |ch_line|
          if ch_line != nil && ch_line["left"] == left
            ch_line["status"] = 1
            g_cnt += 1
            cnt_errors = exist_pairs(st_line["rules"], ch_line["rules"])
            if (cnt_errors > 0)
              mistakes[4] += cnt_errors
              ch_line["status"] = 1
              description = ch_line["left"]
              description += " ::= "
              _cnt = 0
              if ch_line["rules"] != nil
                ch_line["rules"].each do |var|
                  if var != nil
                    if _cnt > 0
                      description += '| '
                    end
                    var.each do |elem|
                      description += elem
                      description += " "
                    end
                  end
                  _cnt += 1
                end
              end
              log << "БНФ : строка \"#{description}\" неверна"
            end
          end
        end
      end
    end
    if g_cnt > 1
      log << "Более одной строки описывают #{left}"
      mistakes[3] += 1
    else
      if g_cnt == 0
        mistakes[6] += 1
        log << "Строка с описанием #{left} отсутствует"
      end
    end
  end

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
    #добавляет поле статуса
    bnf.each do |line|
      if line != nil && line["left"] != nil
        line["status"] = 0
        line["left"].gsub! '&lt;', ''
        line["left"].gsub! '&gt;', ''
        if line["rules"] != nil
          line["rules"].each do |variant|
            if variant != nil
              variant.each do |word|
                word.gsub! '&lt;', ''
                word.gsub! '&gt;', ''
              end
            end
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
    #Слово не принадлежащее групе - ошибка типа 10
    groups_to_check.each do |key, group|
      if group["type"] != "group"
        mistakes[6] += 1
        log << "Слово \"#{group["data"]}\" не состоит ни в одной группе"
      end
    end
    #берём каждое слово предложения, ищем группы, в которые оно входит
    sen_id = -1
    generate_task(standard_groups).each do |sentence|
      sen_id += 1
      sentence.split(" ").each do |word|
        #флаг будет истинным, если слово в ответе и вопросе в разных категориях групп
        #т.е. в именной и не именной
        flag = false
        gr_flag = ""
        cnt_mist = -1
        group_size = 6
        standard_groups.each do |key, st_group|
          words = st_group["data"].split(" ")
          words.each do |pret_word|
            if ( ( word == pret_word ) && ( sen_id.to_s == st_group["sentence"] ) )
              #найдена группа, в составе которой находится текущее слово
              if st_group["type"] != "group"
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
                        !Not_name.include?(ch_group["groupName"]) ) ||
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
                            if st_line != nil && st_line["left"] == st_group["groupName"] && !bnf_correct
                              #нашли нужную строку в эталоне
                              bnf_to_check.each do |ch_line|
                                if ch_line != nil && ch_line["left"] == ch_group["groupName"] && !bnf_correct
                                  #нашли нужную строку в ответе студента
                                  #проставить ей статус
                                  bnf_flag = true
                                  if st_line["rules"].eql?(ch_line["rules"])
                                    bnf_correct = true
                                    st_line["status"] = ch_line["status"] = 1
                                  end
                                  #если найдено корректное соответствие, то там выставлен статуc 1
                                end
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
                            group_size = words.size
                            gr_flag = st_group["groupName"]
                          end
                        end
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
          mistakes[5] += 1
          log << "Слово \"#{word}\" отнесено к разным типам групп ИГ/не ИГ"
        else
          if Not_name.include?(gr_flag)
            #выставить ошибку описания неименной группы
            if gr_flag == "П"
              if cnt_mist != 0
                if (group_size == 1)
                  mistakes[8] += 1
                elsif (group_size == 2)
                  mistakes[5] += 1
                else
                  mistakes[4] += 1
                end
                log << "Слово \"#{word}\" отнесено к предикату, но он отличается от эталонного"
              end
            else
              if cnt_mist != 0
                if (group_size == 1)
                  mistakes[4] += 1
                elsif (group_size == 2)
                  mistakes[3] += 1
                else
                  mistakes[2] += 1
                end
                log << "Слово \"#{word}\" отнесено к С,ВС или Н, но группа отличается от эталонной"
              end
            end
          else
            if gr_flag != "Слово"
              #выставить ошибку описания именной группы
              if cnt_mist !=0
                if (group_size > 8)
                  mistakes[1] += 1
                elsif (group_size == 1)
                  mistakes[7] += 1
                elsif (group_size == 2)
                  mistakes[4] += 1
                elsif (group_size < 5)
                  mistakes[3] += 1
                else
                  mistakes[2] += 1
                end
                log << "Слово \"#{word}\" отнесено к ИГ, но она отличается от эталонной"
              end
            end
          end
        end
      end
    end
    #проверка БНФ для G
    check_g_part(standard_bnf, bnf_to_check, G, log, mistakes)
    check_g_part(standard_bnf, bnf_to_check, Order, log, mistakes)
    check_g_part(standard_bnf, bnf_to_check, Question, log, mistakes)
    check_g_part(standard_bnf, bnf_to_check, Message, log, mistakes)
    #прибавка ошибок из-за лишних/несовпадающих/отсутствующих строк
    standard_bnf.each do |line|
      if line != nil && line["status"] == 0 && line["left"] != nil
        mistakes[3] += 1
        description = line["left"]
        description += " ::= "
        _cnt = 0
        if line["rules"] != nil
          line["rules"].each do |var|
            if var != nil
              if _cnt > 0
                description += '|'
              end
              var.each do |elem|
                description += elem
                description += " "
              end
            end
            _cnt += 1
          end
        end
        log << "БНФ : строка #{description} отсутствует, несовпадает или группа слов, описываемая этой строкой несовпадает"
      end
    end

    bnf_to_check.each do |line|
      if line != nil && line["status"] == 0 && line["left"] != nil
        mistakes[3] += 1
        description = line["left"]
        description += " ::= "
        _cnt = 0
        if line["rules"] != nil
          line["rules"].each do |var|
            if var != nil
              if _cnt > 0
                description += '|'
              end
              var.each do |elem|
                description += elem
                description += " "
              end
            end
            _cnt += 1
          end
        end
        log << "БНФ : строка #{description} лишняя, несовпадает или группа слов, описываемая этой строкой несовпадает"
      end
    end

    mark = 100
    for id in 0..10
      mark -= mistakes[id]*Cost[id]
    end
    if mark < 0
      mark = 0
    end
    return mark, mistakes.to_s, log.join("\n")
  end

end
