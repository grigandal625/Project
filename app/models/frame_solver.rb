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
    checkframes()
    checkGenericFrames()
    checkAko()
    checkOther()
  end


  def checkOther 
     countForAllFrames = 45.0
     eframes = etalonframe.frames
     sframes = studentframe.frames
     countOfValues = 0.0
     valueFinded = 0
     typesFinded = 0

     for ef in eframes
       for es in ef.children
         for ev in es.children
           countOfValues += 1
           sv = findValue(ef.name,  es.name, ev.name)
	   if sv
              valueFinded += 1
              if sv.type == ev.type
		 typesFinded += 1
              end
           end 
         end
       end
     end
     eachBonusValue = (countForAllFrames) /( countOfValues / 0.3  ) 
     eachBonusType  = (countForAllFrames) /( countOfValues / 0.7  ) 
     self.result += valueFinded * eachBonusValue + typesFinded * eachBonusType
  end

  def findValue(framename, slotname, valuename)
     sframes = studentframe.frames
     for sf in sframes
       for ss in sf.children
         for sv in ss.children
           if sf.name == framename and ss.name == slotname and sv.name == valuename
 	     return sv
           end
         end
       end
     end 
     return nil
  end


  def checkAko
    countForAllFrames = 20.0
    eframes = getFramesWithAkoSlot ( etalonframe.frames )
    sframes = getFramesWithAkoSlot ( studentframe.frames )
    countOfCorrectAko = 0
    countOfAko = 0


    for ef in eframes
      for sf in sframes
        es = getAkoSlot(ef)
        ss = getAkoSlot(sf)
        if ef.name == sf.name
          for akoE in es
            countOfAko += 1
            for akoS in ss 
              if akoE.name == akoS.name
                countOfCorrectAko += 1
              end
            end
          end
        end
      end      
    end

    eachBonus = countForAllFrames / countOfAko
    self.result += countOfCorrectAko * eachBonus
  end


  def getFramesWithAkoSlot( frames )
    result = []
    for fr in frames 
      for child in fr.children 
        if child.name == "ako"
          result.push(fr)
        end
      end
    end 
    return result
  end

  def getAkoSlot(frame)
    for child in frame.children  
      if child.name == "ako"
        return child.children
      end
    end
    return nil
  end


  def checkframes
    countForAllFrames = 15.0
    eframes = etalonframe.frames
    sframes = studentframe.frames
    foundFrames = 0
    sizeOfEFrames = eframes.size
    sizeOfSFrames = sframes.size
    eachBonus = countForAllFrames / sizeOfEFrames
    eachTax   = sizeOfSFrames > sizeOfEFrames ? eachBonus * (sizeOfSFrames - sizeOfEFrames) : 0
    for ef in eframes
      for sf in sframes
	      if ef.name == sf.name
	        foundFrames += 1
        end
      end
    end
    self.result += foundFrames * eachBonus - eachTax
  end

  def getCountOfGenericFrames( setOfFrames )
    countOfGenericFrames = 0
    frames = setOfFrames
    for f in frames
      for fchild in  f.children
        if fchild.type == "classification" and fchild.name == "generic"
          countOfGenericFrames += 1
        end
      end
    end
    return countOfGenericFrames
  end

  def getGenericFrames( setOfFrames )
    genericFrames = []
    frames = etalonframe.frames
    for f in frames
      for fchild in  f.children
        if fchild.type == "classification" and fchild.name == "generic"
          genericFrames.push(f)
        end
      end
    end
    return genericFrames
  end

  def checkGenericFrames
    countForAllFrames = 20.0
    eframes = getGenericFrames( etalonframe.frames )
    sframes = getGenericFrames( studentframe.frames )
    eachBonus = countForAllFrames / eframes.size
    eachTax = eframes.size < sframes.size ? eachBonus * (sframes.size - eframes.size) : 0
    foundFrames = 0
    for ef in eframes
      for sf in sframes
	      if ef.name == sf.name
	        foundFrames += 1
        end
      end
    end
    self.result += foundFrames * eachBonus - eachTax
  end


end
