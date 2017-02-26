class Framesmistakes < ActiveRecord::Base
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


  def addMistake(json)

    framemistakes = Framesmistakes.new
    framemistakes.mistakes = json
    frame.save()
  end

end
