class FrameSolver
  attr_accessor :studentframe
  attr_accessor :etalonframe
  attr_accessor :mistakes
  attr_accessor :result


  def inic(studentframe, etalonframe)
    self.studentframe = studentframe
    self.etalonframe = etalonframe
    self.result = 0
    self.mistakes = []
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
      end
    end
  end

# Проверка количества слотов в эталоне и в фрейме построенным студентом 20
def slotssize(eframe, sframe)
  if eframe.children.size != sframe.children.size
    self.result = self.result - 20
    self.mistakes << "Неверное количество слотов " + eframe.name
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
          end
          find = true
          valuename(eframe,sframe)
          if eframe.type != sframe.type

            self.result = self.result - 5
            self.mistakes << "Неверный тип" + eframe.name
          end

          # Колво слотов

        end
      end
      if ! find
        self.result = self.result - 10
        self.mistakes << "Значение ненайдено " + eframe.name
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
          end
        end
      end

      if ! find
        self.result = self.result - 10
        self.mistakes << "Значение не найдено " + eslot.name
      end
    end
  end

  def getmistake
    if self.result < 0
      self.result = 0
    end
  end

end
