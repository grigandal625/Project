#coding: utf-8

class SAnswer < ActiveRecord::Base
  belongs_to :task

  def check_answer(answer_to_check)
    log = []
    mistakes = []
    for i in 0..10
      mistakes << 0
    end
    c_answer = JSON.parse(answer_to_check) 
    mark = 100
    standart_answer = JSON.parse(answer)
    for i in 0..2
      if c_answer[i] == nil
        mistakes[9] += 2
        log << "Не введен ответ на \"#{i+1}\"-е предложение."
        mark -= 40;
        next
      end
      if c_answer[i].length < 2
        mistakes[9] += 2
        log << "Введен слишком короткий ответ на \"#{i+1}\"-е предложение."
        mark -= 40;
        next
      end
      if c_answer[i][0]["num"] != standart_answer[i][0]["num"]
        mistakes[3] += 1
        log << "\"#{i+1}\"-е предложение: неправильно выбран предикат"
        mark -= 5
      else
        if c_answer[i][0]["word"] != standart_answer[i][0]["word"]
          mistakes[3] += 1
          log << "\"#{i+1}\"-е предложение: неправильно записана н/ф предиката."
          mark -= 5
        end
        if c_answer[i][0]["param"] != standart_answer[i][0]["param"]
          mistakes[3] += 1
          log << "\"#{i+1}\"-е предложение: неправильно определено время или вид предиката."
          mark -= 5
        end
      end

      len = standart_answer[i].length
      parents = []
      for j in 1...len
        parents[standart_answer[i][j]["level"].to_i] = standart_answer[i][j]["num"]
        if standart_answer[i][j]["level"].to_i == 1
          k = 1
          while k < c_answer[i].length
            if c_answer[i][k]["num"] == standart_answer[i][j]["num"]
              break
            end
            k += 1
          end
          if k == c_answer[i].length
            mistakes[3] += 1
            log << "#{i+1}-е предложение: не найден актант \"#{standart_answer[i][j]["word"]}\""
            mark -= 5 
          else
            
            if c_answer[i][k]["level"] != standart_answer[i][j]["level"]
              mistakes[3] += 1
              log << "#{i+1}-е предложение: неверно выбран уровень актанта \"#{standart_answer[i][j]["word"]}\""
              mark -= 5
            end
            if c_answer[i][k]["word"] != standart_answer[i][j]["word"]
              mistakes[2] += 1
              log << "#{i+1}-е предложение: неверно записана н/ф \"#{standart_answer[i][j]["word"]}\""
              mark -= 3
            end
            if c_answer[i][k]["param"] != standart_answer[i][j]["param"]
              mistakes[2] += 1
              log << "#{i+1}-е предложение: неверно выбран тип актанта \"#{standart_answer[i][j]["word"]}\""
              mark -= 3
            end
            c_answer[i][k]["seen"] = 1
          end  
        else
          k = 1
          while k < c_answer[i].length
            if c_answer[i][k]["num"] == standart_answer[i][j]["num"]
              break
            end
            k += 1
          end 
puts k
puts c_answer[i].length
          if k == c_answer[i].length
            mark -= 2
            mistakes[1] += 1
            log << "#{i+1}-е предложение: не найдено слово \"#{standart_answer[i][j]["word"]}\""
          else
            if c_answer[i][k]["word"] != standart_answer[i][j]["word"]
              mistakes[1] += 1
              log << "#{i+1}-е предложение: неверно записано слово \"#{standart_answer[i][j]["word"]}\""
              mark -= 2
            end
            if c_answer[i][k]["level"] != standart_answer[i][j]["level"]
              mistakes[1] += 1
              log << "#{i+1}-е предложение: неверно записан уровень слова \"#{standart_answer[i][j]["word"]}\""
              mark -= 2
            end
            if c_answer[i][k]["level"].to_i == 1
              mark -= 3
            end
            if c_answer[i][k]["param"] != standart_answer[i][j]["param"]
              mistakes[1] += 1
              log << "#{i+1}-е предложение: неверно выбран тип слова \"#{standart_answer[i][j]["word"]}\""
              mark -= 2
            end
            t = k
            while c_answer[i][k]["level"] <= c_answer[i][t]["level"]             
              t -= 1
            end 
#-----------------------
            if parents[c_answer[i][t]["level"].to_i - 1] != c_answer[i][t]["num"] 
              mistakes[1] += 1
              log << "#{i+1}-е предложение: неверно выбран родитель слова \"#{standart_answer[i][j]["word"]}\""
              mark -= 2
            end
            c_answer[i][k]["seen"] = 1
          end 

        end    
      end

      len = c_answer[i].length
      for j in 1...len
        if c_answer[i][j]["seen"] == nil
          if c_answer[i][j]["level"].to_i == 1
            mistakes[3] += 1
            log << "#{i+1}-е предложение: лишнее слово \"#{c_answer[i][j]["word"]}\""
            mark -= 5
          else
            mistakes[2] += 1
            log << "#{i+1}-е предложение: лишнее слово \"#{c_answer[i][j]["word"]}\""
            mark -= 3
          end
        end
      end      
    end
    
    if mark < 0
      mark = 0
    end
    return mark, mistakes.to_s, log.join("\n")
  end
end
