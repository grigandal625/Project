#coding: utf-8
class FrameSolver
  attr_accessor :studentframe
  attr_accessor :etalonframe
  attr_accessor :mistakes
  attr_accessor :result

  attr_accessor :omistake


  def inic(studentframe, etalonframe)
    self.studentframe = studentframe
    self.etalonframe = etalonframe
    self.result = 0
    self.mistakes = []
    self.omistake = Frameobjectmistake.new
  end


  def getstring
    temp = ""
    temp = temp +  omistake.framenamemistakes.to_s + ","
    temp = temp +  omistake.slotsSizeMistakes.to_s + ","
    temp = temp +  omistake.nameSlotsMistakes.to_s + ","
    temp = temp +  omistake.typeSlotsMistakes.to_s + ","
    temp = temp +  omistake.valueSizeMistakes.to_s + ","
    temp = temp +  omistake.valuetypeMistakes.to_s + ","
    temp = temp +  omistake.valuenotFoundMistakes.to_s
    return temp



  end
  # Проверка написания студентом всех фреймов. В случае не описанного фрейма ошибка 50

  def differentnames
    mistake = 0
    etalonframe.frames.each do |eframe|
      find = false
      studentframe.frames.each do |sframe|
        if eframe.name == sframe.name
          find = true
          # Колво слотов
          slotssize(eframe, sframe) #
          # название слотов
          slotsname(eframe, sframe)
        end
      end
      if ! find
        self.result = self.result - 50
        self.mistakes << "Ненайден фрейм " + eframe.name
        self.omistake.framenamemistakes += 1
      end
    end
    self.omistake.saveobject
  end

# Проверка количества слотов в эталоне и в фрейме построенным студентом 20
def slotssize(eframe, sframe)
  if eframe.children.size != sframe.children.size
    self.result = self.result - 20
    self.mistakes << "Неверное количество слотов " + eframe.name
    self.omistake.slotsSizeMistakes += 1
  end
end


  #Проверка имен слотов, а так же типа слота
  def slotsname(etalonf, studentf)
    etalonf.children.each do |eframe|
      find = false
      studentf.children.each do |sframe|
        if eframe.name == sframe.name
          if eframe.children.size != sframe.children.size
            self.result = self.result - 10
            self.mistakes << "Неверное количество значений " + eframe.name
            self.omistake.nameSlotsMistakes += 1
          end
          find = true
          valuename(eframe,sframe)
          if eframe.type != sframe.type

            self.result = self.result - 5
            self.mistakes << "Неверный тип" + eframe.name
            self.omistake.typeSlotsMistakes += 1
          end

          # Колво слотов

        end
      end
      if ! find
        self.result = self.result - 10
        self.mistakes << "Значение ненайдено " + eframe.name
        self.omistake.valuenotFoundMistakes += 1
      end
    end
  end


  def valuename(etalonslot, studentslot)
    etalonslot.children.each do |eslot|
      find = false
      studentslot.children.each do |sslot|
        if eslot.name == sslot.name
          find = true
          if eslot.type != sslot.type
            self.result = self.result - 5
            self.mistakes << "Неверный тип " + eslot.name
            self.omistake.valuetypeMistakes += 1
          end
        end
      end

      if ! find
        self.result = self.result - 10
        self.mistakes << "Значение не найдено " + eslot.name
        self.omistake.valuenotFoundMistakes +1
      end
    end
  end

  def getmistake
    if self.result < 0
      self.result = 0
    end
  end



end
