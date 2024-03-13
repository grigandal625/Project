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
#----------40 - FQUERY  Меньше 3 параметров ---------------------------------------------#
#----------41 - FQUERY  Нет выражения (4 параметр)---------------------------------------#
#----------42 - FQUERY  Неверный тип-----------------------------------------------------#
#-----42.5 - FQUERY  4 параметр задан как массив, это не ошибка, но пока нет обработки---#
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
 (ako (value (имя фрейма)))
  (classification (value(generic/individual)))
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

  # Поиск Слота по имени в Фрейме
  def getSlotByName(frame, name)
    for slot in frame.children
      if slot.type == "fslot" and slot.name == name
        return slot
      end
    end
    return nil
  end
  
  # Поиск Аспекта по имени в слоте
  def getAspectByName(slot, name)
    for aspect in slot.children
      if aspect.name == name
        return aspect
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
      self.values = ["value", "default", "require", "prefer", "if-needed"]
      self.frames = []
      self.forUser = []
      self.etalontree = tree
      self.dictionary = staticarray
    end

  end

  def isuseframe?(name)
    frames.each do |frame|
      if frame.name == name
        makemistake(5)
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
    fr = Framedb.new
    fr.code = ""
    while etalontree.find(i) != nil
      funcname = etalontree.find(i).struct[0]
      if funcname == "fassert"
        if etalontree.find(i).struct.length == 2
          if not isuseframe?(etalontree.find(i).struct[1])
            fassert(etalontree.find(i).struct[1], etalontree.find(i).children)
          else
            makemistake(100)
          end
        else
          makemistake(1)
        end

      end
      if funcname == "fget"

        if etalontree.find(i).struct.length >= 2
          #fget(i)
          gotframe =find_object(etalontree.find(i).struct[1..-1])
          if (gotframe != nil)
            forUser.push(gotframe)
          else
            makemistake(17)
          end


        else
          makemistake(2)
        end

      end
      if funcname == "fput"
        fputMod(etalontree.find(i).struct[1..-1], etalontree.find(i).children)
      end
      if funcname == "fdelete"
        if etalontree.find(i).struct.size > 2
          delete(etalontree.find(i).struct[1..-1])
        else
          makemistake(30)
        end
      end
      if funcname == "fquery"
      #Func type ( FrameName or Nil , Slot or nil , aspect, Predicat 
        fqeury(etalontree.find(i))
      end
      	
      i = i + 1
    end
    return fr


  end

  def getChildrenNamesForFrame(frame)
    childrennames = []
    for fr in frame.children
      if fr.name == "ako"
         for akofr in fr.children
 	   childrennames.push(akofr.name)
         end
      end
    end
    return childrennames
  end

  def getUsedFrames
    framenames = []
    for fr in frames
      framenames.push(fr.name)
    end
    return framenames
  end

  def getUsedFrameSize
    return frames.size
  end

  def fqeury(value)
    typesforrequest = ["value", "default"]
    #fqeurysize = value.size - 1
    #if value.size < 3
    #	mistakes << 40
    #end
    print("-----FQEURY START-----")
    mainValue = value.struct
    childrenValue = value.children
    if mainValue.size > 3
      framename = mainValue[1]
      slotname =  mainValue[2]
      type = 	  mainValue[3]
      child = nil
      print ( childrenValue.size)
      if mainValue.size == 5 
	child = mainValue[4]
      elsif mainValue.size == 4 and not (childrenValue.empty?)
	child = childrenValue
      elsif mainValue.size == 4 and childrenValue.empty?
	makemistake(41)
	return
      end
      if not typesforrequest.include?(type)
        makemistake(42)
        return
      end
      if not child.class == Array
	print("Not Array")
      else
        makemistake(42.5)
      end 
      if framename == "nil" and slotname == "nil" and child == "nil" 
	return "nil"
      end
      if framename == "nil" and not(slotname == "nil")
	framesFind = []
      	#check all created frames 
	for fr in frames
	  for slot in fr.children
 	    if slot.name == slotname
	      for ch in slot.children
	        if ch.name == child and ch.type == type
		  framesFind.push(fr.name)
		end
	      end
	    end
	  end
	end
	print(framesFind.to_json)
      end
     
    else
      makemistake(40)
      return
    end

  end 

  def saveframe(fr)
    fr.code  = forUser.to_json
    fr.name = mistakes.to_json
    fr.save()
  end

  private

  def makemistake( num )
    mistakes << num
  end



  def findpath(startpoint, struct)
    #Начальная точка и массив struct

    if ffindpath(startpoint, struct) == nil
      if ffindpathwithtype(startpoint, struct) == nil
        makemistake(17)
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

  def getAkoSlotForFrame(frame)
    for fr in frame.children
      if fr.name == "ako"
	return fr
      end
    end
    frame.children.push(Frameobject.new("ako", "fslot", []))
    return getAkoSlotForFrame(frame)
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

        fassert_akoMod(slot, frame)

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

    if (not (frame.nil?)) and (frame.type == "frame")
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
            makemistake(101)
          end

        else
          mistakes << "неверное число параметров"
        end
      end
    end
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
          makemistake(17)
          return
        end
      end
      path = path[1..-1]
      while path.size > 0
        findframe = get_child(findframe, path[0])
        path = path[1..-1]
        if findframe == nil
          makemistake(17)
          return
        end
      end

      if findframe != nil

        return findframe
      else
        makemistake(17)
        return nil
      end
    end
  end

  def fassert_akoMod(slot, frame)
    # take newframes in one function 
    # example (ako (value f1 ... fn ) ... (value fk+1 ... fm) )
    slotname = slot.struct[0]
    framename = frame.name

    addframenames = []
    for fr in slot.children
      print(fr.to_json)
      if fr.struct[0] == 'value'
        for subfr in fr.children
          for frname in subfr.struct
            addframenames.push(frname)
          end
        end
      else
        for frname in fr.struct[1..-1]
          addframenames.push(frname)
        end
      end
    end
    
    frameChildren = getChildrenNamesForFrame(frame)
    addframenames = addframenames - frameChildren - [framename]
    akoslot = getAkoSlotForFrame(frame)
    for addframename in addframenames
    	akoslot.children.push(findFrameByName(addframename))
	addfr = getframe(addframename)
	for addframeslot in addfr.children
	  if addframeslot.type == "classification" and addframeslot.name == "generic"
	    addFrameSlotsFromGenericFrame(frame, addfr)
	  end
	end
    end    
  end

  def addFrameSlotsFromGenericFrame(toFrame, fromFrame)
    isGeneric = false
    for slot in toFrame.children
      if slot.type == "classification" and slot.name == "generic"
        isGeneric = true
      end
    end
    for slot in fromFrame.children 
      if slot.type == "fslot" and not (isHaveSlot?(toFrame, slot.name))
	newSlotChildren = []
        for child in slot.children 
	  if child.type == "default" and not(isGeneric) 
	    newSlotChildren.push(Frameobject.new(child.name, "value", []))
	  elsif child.type == "default" and isGeneric
	    newSlotChildren.push(Frameobject.new(child.name, "default", []))
	  end
	end
        newSlot = Frameobject.new(slot.name, slot.type, newSlotChildren)
	toFrame.children.push(newSlot)
      end
    end
  end

  def isHaveSlot?(frame, slotname)
    for slot in frame.children
      if slot.name == slotname
        return true
      end
    end
    return false
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
                makemistake(16) #Фрейм ненайден
              end
            else
              makemistake(15) # Повтор
            end
          else
            makemistake(14) # непонятный тип
          end
        else
          makemistake(13)
        end
      end
    else
      makemistake(12)
    end
  end


  def fassert_slot(slot, frame)
    if not islink?(frame, slot.struct[0])
      lastslot = Frameobject.new(slot.struct[0], "fslot", [])
      frame.children.push(lastslot)
      aspect = slot.children
      fassert_value(aspect, lastslot)
    else
      lastslot = getSlotByName(frame, slot.struct[0])
      lastslot.children = []
      aspect = slot.children
      fassert_value(aspect, lastslot)
    end


      ##rewrite to Slot
      ##makemistake(6)
  end

  def fassert_value(aspect, slot)
      aspect.each do |faspect|
        if values.include?(faspect.struct[0])
          value = faspect.children
          value.each do |value|
            if not islink?(slot, value.struct[0])
              slot.children.push(Frameobject.new(value.struct[0], faspect.struct[0], []))
            else
              makemistake(8)
            end
	  end
        else
          makemistake(7)
        end
      end
  end

  def fassert_classification(slot, frame)
    if not islinktype?(frame, "classification")
      if (slot.children.size == 1 )
        slot_value = slot.children[0].struct[0]
        if slot_value == 'value'
          slot_value = slot.children[0].children[0].struct[0]
        end
        if slot.children[0].struct.size == 1 and classification.include?(slot_value)
          lastslot = Frameobject.new(slot_value, "classification", [])
          frame.children.push(lastslot)
        else
          makemistake(10)
        end
      else
        makemistake(9)
      end
    else 
      makemistake(11)
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
