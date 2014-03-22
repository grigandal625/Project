#coding: utf-8

class SAnswer < ActiveRecord::Base
  belongs_to :task

  def check_answer(answer_to_check)
    st_answer = JSON.parse(answer_to_check)
    standart_answer = JSON.parse(answer)
    mark = 100
    for i in 0..2
      if c_answer[i] == nil
        mark = 0
        break
      end
      if c_answer[i].length < 2
        mark = 0
        break
      end
      if c_answer[i][0][:num] != standart_answer[i][0][:num]
        mark -= 5
      end
      if c_answer[i][0][:word] != standart_answer[i][0][:word]
        mark -= 5
      end
      if c_answer[i][0][:param] != standart_answer[i][0][:param]
        mark -= 5
      end

      len = c_answer[i].length
      parents = []
      for j in 1...len
        parents[standart_answer[i][j][:level]] = standart_answer[i][j][:num]
        if standart_answer[i][j][:level] == 1
          k = 1
          while k < c_answer[i].length
            if c_answer[i][k][:num] == standart_answer[i][j][:num]
              break
            end
            k += 1
          end
          if k == c_answer[k].length
            mark -= 5
          else
            if c_answer[i][k][:word] != standart_answer[i][j][:word]
              mark -= 3
            end
            if c_answer[i][k][:level] != standart_answer[i][j][:level]
              mark -= 5
            end
            if c_answer[i][k][:param] != standart_answer[i][j][:param]
              mark -= 3
            end
            c_answer[i][k][:seen] = 1
          end  
        else
          k = 1
          while k < c_answer[i].length
            if c_answer[i][k][:num] == standart_answer[i][j][:num]
              break
            end
            k += 1
          end 
          if k == c_answer[i].length
            mark -= 2
          else
            if c_answer[i][k][:word] != standart_answer[i][j][:word]
              mark -= 2
            end
            if c_answer[i][k][:level] != standart_answer[i][j][:level]
              mark -= 2
            end
            if c_answer[i][k][:level] == 1
              mark -= 3
            end
            if c_answer[i][k][:param] != standart_answer[i][j][:param]
              mark -= 2
            end
            t = k
            while c_answer[i][k][:level] >= c_answer[i][t][:level]             
              t -= 1
            end 
            if parents[c_answer[i][t][:level]] != c_answer[i][t][:num] 
              mark -= 2
            c_answer[i][k][:seen] = 1
          end 

        end    
      end

      len = c_answer[i].length
      for j in 1...len
        if c_answer[i][j][:seen] == nil
          if c_answer[i][j][:level] == 1
            mark -= 5
          else
            mark -= 3
          end
        end
      end      
    end
    

    return mark
  end
end
