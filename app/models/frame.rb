#coding: utf-8
class Frame
  attr_accessor :etalontree         # Лексическое дерево
  attr_accessor :mistakes           # Ошибки трансляции
  attr_accessor :frames             # Используемые фреймы
  attr_accessor :inherit            # Массив слов наследования
  attr_accessor :classification     # Массив Слов Классификации
  attr_accessor :values             # Массив Value
  attr_accessor :dictionary         # Словарь
  attr_accessor :fslots             # Слот
  attr_accessor :forUser            # Информация для пользователя



=begin
##########################################################################################
#------------------------Ошибки в ходе трансляции----------------------------------------#
#-----------1 - FASSERT неверное число параметров лишние параметры ----------------------#
#-----------2 - FGET неверное число параметров лишние параметры -------------------------#
#-----------3 - FPUT неверное число параметров лишние параметры -------------------------#
#-----------4 - FDELETE неверное число параметров лишние параметры ----------------------#
#-----------5 - FASSERT Данный фрейм уже существует--------------------------------------#
#-----------6 - FASSERT Дублирование слота-----------------------------------------------#
#-----------7 - FASSERT Ошибка типа -----------------------------------------------------#
#-----------8 - FASSERT Дублирование значения -------------------------------------------#
#-----------9 - FASSERT Неверное число параметров Classification ------------------------#
#----------10 - FASSERT Ошибка в значение Classification --------------------------------#
#----------11 - FASSERT Дублирование Classification  ------------------------------------#
#----------12 - FASSERT AKO Повторное использовани --------------------------------------#
#----------13 - FASSERT AKO неверное число параметров------------------------------------#
#----------14 - FASSERT AKO Неизвестный тип  --------------------------------------------#
#----------15 - FASSERT AKO повторное наследование --------------------------------------#
#----------16 - FASSERT AKO Фрейм ненайден ----------------------------------------------#
#----------17 - FGET  Фрейм ненайден ----------------------------------------------------#
#----------30 - FDELETE  неверное число параметров --------------------------------------#
#----------100 - FASSERT Создание существующего фрейма ----------------------------------#
#----------101 - FPUT Ошибка типа -------------------------------------------------------#
#----------300 - Ошибка скобок 000 ------------------------------------------------------#
#----------203 - Лексическая ошибка -----------------------------------------------------#
##########################################################################################
################################Autor iAppleJack##########################################
##########################################################################################
##########################################################################################
#----------18/12/14 Весия 1.1 поддержка функция -----------------------------------------#
#----------=begin fassert , fput, fdelete, fget -----------------------------------------#
#---------- Обнаружена ошибка наследования на себя приводящая к бесконечному циклу ------#
-----------=end -------------------------------------------------------------------------#
##########################################################################################
##########################################################################################



Синтаксис
(fassert имя фрейма
  (имя слота
    (
    тип
      (
        значение
      )
    )
  )
 (ako (value имя фрейма))
  (classification (generic/individual))
)
=end


  def new # создание пустого

  end

  def getframe(name)
    frames.each do |frame|
      if frame.name == name
        return frame
      end
    end
    return nil
  end

  def inic(message) # Инициализация фрейма
    self.mistakes = []
    staticarray = ["root", "fslot", "frame?", "frame+", "fput", "fassert"]
    tokenline = Tokenline.new()

    tokens = tokenline.parsestringmod(message)
    tree = tokenline.getTree(tokens, staticarray)
    self.mistakes = tokenline.mistakes

    if (tree.instance_of?(Fixnum))
      print("exeption" + tree.to_s)
    else
      self.inherit =  ["ako", "instance"]
      self.classification =  [ "generic", "individual"]
      self.values = ["value", "default", "require", "prefer", "if_needed"]
      self.frames = []
      self.forUser = []
      self.etalontree = tree
      self.dictionary = staticarray
    end

  end

  def isuseframe?(name)
    frames.each do |frame|
      if frame.name == name
        mistakes << 5
        return true
      end
    end
    return false
  end

  def frameadd(newframelist)
    newframelist.frames.each do |newframe|
      if not isuseframe?(newframe.name)
        self.frames.push(newframe)
      end
    end

  end

  def findFrameByName(name)
    frames.each do |frame|
      if frame.name == name
        return frame
      end
    end
    frame = Framedb.get_frame_from_name(name) #Строка поиска других фреймов в бд
    #frame = nil
    if frame != nil
      ######
      ######
      ######
      differentFrame = Frame.new
      differentFrame.inic(frame.code)
      differentFrame.createframe(frame.code)
      gotFrame = differentFrame.getframe(name)
      frameadd(differentFrame)

      return gotFrame

    end
    return nil
  end


  def getdictionary
    dic = [] # словарь фрейма
    frames.each do |frame|
      getdic(dic, frame)
    end
    return dic.uniq
  end


  def createframe(message)
    i = 0
    fr = Framedb.find(3)
    fr.code = ""
    while etalontree.find(i) != nil
      if etalontree.find(i).struct[0] == "fassert"
        if etalontree.find(i).struct.length == 2
          if not isuseframe?(etalontree.find(i).struct[1])
            fassert(etalontree.find(i).struct[1], etalontree.find(i).children)
          else
            mistakes << 100
          end
        else
          mistakes << 1
        end

      end
      if etalontree.find(i).struct[0] == "fget"

        if etalontree.find(i).struct.length >= 2
          #fget(i)
          gotframe =find_object(etalontree.find(i).struct[1..-1])
          if (gotframe != nil)
            forUser.push(gotframe)
          else
            mistakes << 17
          end


        else
          mistakes << 2
        end

      end
      if etalontree.find(i).struct[0] == "fput"
        fputMod(etalontree.find(i).struct[1..-1], etalontree.find(i).children)
=begin        if etalontree.find(i).struct.length >= 2

          foundframe = findFrameByName(etalontree.find(i).struct[1])
          if (foundframe != nil )
            if  etalontree.find(i).struct.length == 2


            end
          else
            mistakes << 19
          end
          if etalontree.find(i).struct.length > 2

            #findpath(foundframe, etalontree.find(i).struct[2..-1])

            foundframe = findpath(foundframe, etalontree.find(i).struct[2..-1])
            #mistakes.push(etalontree.find(i).struct[2])

          end
          if foundframe != nil

            put_in_frame = etalontree.find(i).children
            put_in_frame.each do |frameobject|
            roottree = foundframe
              while frameobject.struct.size > 1
                #forUser.push("put_in_frame" + frameobject.struct.to_s)
                new_object_name = frameobject.struct[0]
                new_object_type = frameobject.struct[1]
                new_object = Frameobject.new(new_object_name,new_object_type, [])

                roottree.children.push(new_object)
                roottree = new_object
                frameobject.struct = frameobject.struct[2..-1]
              end
            end


          else

          end
        else
          mistakes << 3
        end
=end
      end
      if etalontree.find(i).struct[0] == "fdelete"
        if etalontree.find(i).struct.size > 2
          delete(etalontree.find(i).struct[1..-1])
        else
          mistakes << 30
        end


      end
      i = i + 1
    end

    getnamesuseframes()
    return fr


  end

  def saveframe(fr)
    fr.code  = forUser.to_json
    fr.name = mistakes.to_json
    fr.save()
  end

  private





  def findpath(startpoint, struct)
    #Начальная точка и массив struct

    if ffindpath(startpoint, struct) == nil
      if ffindpathwithtype(startpoint, struct) == nil
        mistakes << 17.0
      else
        return ffindpathwithtype(startpoint, struct)
      end
    else
      return ffindpath(startpoint, struct)
    end


  end

  def getAkoFrameName(frame)
    names = []
    find(frame, names)

  end

  def find(point, names)
    if point.type == "frame"
      names << point.name
    end
    point.children.each do |ako|
      if ako.name == ako or ako.type == "frame"
        find(ako, names)
      end
    end
  end


  def ffindpath(point, struct)
    if struct.size > 0

      point.children.each do |f|
        if f.name == struct[0]
          #Нашли новое состояние

          if struct.size == 1
            return f
          end
          if struct.size > 1
            return ffindpath(f, struct[1..-1])
          end

        end
      end
    end
    return nil
  end

  def ffindpathwithtype(point, struct)
    if struct.size > 1
      point.children.each do |f|
        if f.name == struct[0] and f.type == struct[1]
          #Нашли новое состояние
          if struct.size == 2

            return f
          end
          if struct.size > 2
            return ffindpathwithtype(f, struct[2..-1])
          end

        end
      end
    end
    return nil
  end

#Функция fassert -
#Создает фрейм с именем name, типа frame
#Проводит обход дерева и инициализирует фрейм из лексического дерева children
#children строится на этапе обработке строки класс Tree
#Первая вложенность, к сожалению красиво рекурсивно это сделать довольно сложно проблема возникает когда структуры различны,
#Поэтому сделано в явном виде с большим количеством "быдло" кода
  def fassert(name, children)
    frame =  Frameobject.new(name, "frame", [])
    frames.push(frame)

    children.each do |slot|
      if inherit.include?(slot.struct[0])
        print("Наследование") #Реализована

        fassert_ako(slot, frame)

      elsif "classification" == slot.struct[0]
        print("Классификация") #Реализована
        fassert_classification(slot, frame)
      else
        print("SlOT") #Реализована
        fassert_slot(slot, frame)
      end

    end

  end

  def delete (path)
    delete_name = path[-1]
    delete_object = find_object(path[0..-2])
    for i in 0..delete_object.children.length - 1
      if delete_object.children[i].name == delete_name
        delete_object.children[i] = nil
        delete_object.children = delete_object.children.compact
        return
      end
    end
  end

  def  fputMod(name, children)
    frame = find_object(name)

    if frame.type == "frame"
      children.each do |slot|
        if inherit.include?(slot.struct[0])
          print("Наследование") #Реализована
          fassert_ako(slot, frame)

        elsif "classification" == slot.struct[0]
          print("Классификация") #Реализована
          fassert_classification(slot, frame)
        else
          print("SlOT") #Реализована
          fassert_slot(slot, frame)
        end

      end
    else
      children.each do |child|
        if child.struct.length == 2
          if values.include?(child.struct[0])
            frame.children.push ( Frameobject.new(child.struct[1], child.struct[0], []))
          else
            mistakes << 101
          end

        else
          mistakes << "неверное число параметров"
        end
      end
    end


  end

  def getnamesuseframes()

  end


  def find_object(path)
    if path.size > 0

      findframe = nil
      nameframe = path[0]
      frames.each do |frame|
        if frame.name == nameframe
          findframe = frame
        end
      end
      if findframe == nil
        findframe = findFrameByName(nameframe)

        if findframe = nil
          mistakes << 17
          return
        end
      end
      path = path[1..-1]
      while path.size > 0
        findframe = get_child(findframe, path[0])
        path = path[1..-1]
        if findframe == nil
          mistakes << 17
          return
        end
      end

      if findframe != nil

        return findframe
      else
        mistakes << 17
        return nil
      end
    end
  end


  def fassert_ako(slot, frame)
    if not islink?(frame, slot.struct[0])
      akoslot = Frameobject.new(slot.struct[0], "fslot", [])
      frame.children.push(akoslot)
      slot.children.each do |ako|
        if ako.struct.length == 2
          if  values.include?(ako.struct[0])
            if not islink?(akoslot, ako.struct[1] )
              framecodefromdb = findFrameByName(ako.struct[1])
              if framecodefromdb != nil

                akoslot.children.push(framecodefromdb)


              else
                mistakes << 16 #Фрейм ненайден
              end
            else
              mistakes << 15 # Повтор
            end
          else
            mistakes << 14 # непонятный тип
          end
        else
          mistakes << 13
        end
      end
    else
      mistakes << 12
    end


  end


  def fassert_slot(slot, frame)
    if not islink?(frame, slot.struct[0])
      lastslot = Frameobject.new(slot.struct[0], "fslot", [])
      frame.children.push(lastslot)
      aspect = slot.children
      aspect.each do |faspect|
        if values.include?(faspect.struct[0])
          value = faspect.children
          value.each do |value|
            if not islink?(lastslot, value.struct[0])
              lastslot.children.push(Frameobject.new(value.struct[0], faspect.struct[0], []))
            else
              mistakes << 8
            end
          end
        else
          mistakes << 7
        end
      end
    else
      mistakes << 6
    end
  end

  def fassert_classification(slot, frame)
    if not islinktype?(frame, "classification")
      if (slot.children.size == 1 )
        if slot.children[0].struct.size == 1 and classification.include?(slot.children[0].struct[0])
          lastslot = Frameobject.new(slot.children[0].struct[0], "classification", [])
          frame.children.push(lastslot)
        else
          mistakes << 10
        end
      else
        mistakes << 9
      end
    else mistakes << 11
    end

  end


  #Простая функция поиска связи уровня и его потомков pointtree - передается FrameObject, nametarget - String
  #Поиск на следующем уровне по имени nametarget true/false
  def islink?(pointtree, nametarget)
    pointtree.children.each do |child|

      if nametarget == child.name


        return true
      end
    end
    return false
  end


  def get_child(point, nametarget)
    point.children.each do |frame|
      if frame.name == nametarget
        return frame
      end
    end
    return nil
  end

  def getlink(pointtree, nametarget)
    target = nil
    find = 0

    pointtree.children.each do |child|

      if nametarget == child.name

        target =  child
        find = find + 1
      end
    end
    if find > 1
      return nil
    end
    return target
  end

  def getdic(dic, point)
    dic.push( point.name )
    point.children.each do |nextpoint|
      getdic(dic, nextpoint)
    end
  end

  def islinktype?(pointtree, nametarget)
    pointtree.children.each do |child|
      if nametarget == child.type
        return true
      end
    end
    return false
  end

end
