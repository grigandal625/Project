#coding: utf-8
class Tokenline


###########################
#-------iAppleJack--------#
###########################
  attr_accessor :mistakes        # Ошибки трансляции



  def getstruct (tokens)
    for i in 0..tokens.length - 1
      if i > 0 and tokens[i] == "("
        return tokens[0..(i - 1)]
      end
    end
    return tokens
  end



  def getcount(tokens)
  count = 0;

    for i in 0..tokens.size - 1
      if tokens[i] == '('
        count = count + 1
      end
      if tokens[i] == ')'
        count = count - 1
      end
    end
    if count != 0
      self.mistakes << "300"
    end
  end
  ##
  def getTree(tokens, staticarray)

    key = 0

    tree = Tree.new(key, ["root"], [])
    #self.mistakes = tree.mistakes

    firstchilds = tree.getpart(tokens)


    for i in 0..firstchilds.length - 1
      key = key + 1
      tree.add(0, key,firstchilds[i])
    end
    while tree.findbrackets.uniq.length > 0
      arraykeys  = tree.findbrackets.uniq
      for i in 0..arraykeys.length - 1
        findtree = tree.find(arraykeys[i])

        structelem = tree.find(arraykeys[i]).struct
        structchild = tree.getpart(structelem)

        tree.find(arraykeys[i]).struct = getstruct(tree.find(arraykeys[i]).struct)


        for i in 0..structchild.length - 1
          key = key + 1
          findtree.add(findtree.key, key, structchild[i] )
          exeption = 2
          for k in 0..staticarray.length - 1

            if structchild[i][0] == staticarray[k]
              exeption = 0
              break
            end
          end

        end

      end

    end
    if exeption != 0

      #return exeption
    end
    return tree

  end


#Алгоритм перевода строки в список токенов. Далее этот список будем использовать для построения дерева
#2 состояния 0/1
#Если состояние 0 то считываем символы и если символ из нашей граматики кладем его как токен, если символ буква или знак, то
#считаем его словом и кладем как часть слова (переменная word), и переходим в состояние 1
#В состоянии 1 считываем все буквы и как только нарываемся на скобку кладем это слово, а потом скобку в список токенов переходим в
#состояние 0
#В случае пробела просто кладем слово в список токенов



  def parsestringmod(temp )

    sost = 0
    lexem = []
    count = 0
    exeption = 0
    word = ""
    self.mistakes = []
    getcount(temp)
    string  = temp.downcase

    for i in 0..string.length - 1
      if exeption != 0
        break
      end
      if count == 0
        sost = 0
      end
      if sost == 0 and string[i] == '('
        sost = 1
        count = count + 1
        lexem.push(string[i])
      elsif sost == 1 and string[i] == ')'
        count = count - 1
        lexem.push(string[i])
      elsif sost == 1 and (
      (string[i] >= '+' and string[i] <= '?' ) or
          (string[i] >= 'a' and string[i] <= 'z') or
          (string[i] >= 'а' and string[i] <= 'я') or '_'
      )
        if count > 0
          sost = 2
          word = word + string[i]
        else
          self.mistakes << 200


        end
      elsif sost == 2 and (
      (string[i] >= '+' and string[i] <= '?' ) or
          (string[i] >= 'a' and string[i] <= 'z') or
          (string[i] >= 'а' and string[i] <= 'я') or
          (string[i] >= 'А' and string[i] <= 'Я') or string[i] == '_'
      )
        if count > 0
          word = word + string[i]
        else
          self.mistakes << 201

        end
      elsif sost == 2 and (string[i] == ')' or string[i] == '(')
        if (word.length > 0)
          lexem.push (word)
          word = ""
        end
        lexem.push(string[i])

        if (string[i] == ')')
          count = count - 1
        else
          count = count + 1
        end

      elsif sost == 2 and string[i] == ' '
        if (word.length > 0)
          lexem.push (word)
        end
        word = ""
      end

      if count < 0
        self.mistakes << 202

      end
    end
    if (count != 0)
      self.mistakes << 203
    end
    print ("lexem : ")
    print( lexem)
    print("exeption  : " + exeption.to_s)
    if exeption != 0

    end
    return lexem
  end

end
