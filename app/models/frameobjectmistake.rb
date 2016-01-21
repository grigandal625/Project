class Frameobjectmistake
  attr_accessor :lexicalmistakes
  attr_accessor :sintaxmistakes
  attr_accessor :semanticmistakes
  attr_accessor :framenamemistakes
  attr_accessor :slotsSizeMistakes
  attr_accessor :nameSlotsMistakes
  attr_accessor :typeSlotsMistakes
  attr_accessor :valueSizeMistakes
  attr_accessor :valuetypeMistakes
  attr_accessor :valuenotFoundMistakes

  def initialize()
    self.lexicalmistakes = 0
    self.sintaxmistakes = 0
    self.semanticmistakes= 0
    self.framenamemistakes= 0
    self.slotsSizeMistakes= 0
    self.nameSlotsMistakes= 0
    self.typeSlotsMistakes= 0
    self.valueSizeMistakes= 0
    self.valuetypeMistakes= 0
    self.valuenotFoundMistakes = 0
  end

  def saveobject
    framenamemistakes  = Framesmistakes.new
    framenamemistakes.mistakes = self.to_json
    framenamemistakes.save
    #framenamemistakes.mistakes=
  end
end
