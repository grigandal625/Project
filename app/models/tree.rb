#coding: utf-8
class Tree

  attr_accessor :key
  attr_accessor :struct
  attr_accessor :children
  attr_accessor :mistakes



  def initialize(key, struct, children)
    @key = key
    @struct = struct
    @children = children
    self.mistakes = []
  end



  def sfind(arraykeys)
    if getpart(self.struct).length > 0
      arraykeys.push(self.key)
      return self
    end
    for i in 0..self.children.length - 1
      if self.children[i].sfind(arraykeys) != nil
        self.children[i].sfind(arraykeys)
      end

    end
    return nil
  end

  def findbrackets
    arraykeys = []
    sfind(arraykeys)

    return arraykeys
  end

  def find(number)
    if self.key == number
      return self
    end

    for i in 0..self.children.length - 1
      if self.children[i].find(number) != nil
        return self.children[i].find(number)
      end

    end

    return nil
  end

  def add(lastkey, newkey, data)
    elem = find(lastkey)
    if elem != nil
      elem.children.push(Tree.new(newkey, data, []))
    end
  end


  def tree_data()
    tree_data ||=
        {
            key: @key,
            name: @struct,
            children: @children
        }
  end



  def getpart(tokens)

    parts = []
    sost = 0
    left = 0
    right = 0
    count = 0
    exeption = 0
    for i in 0..tokens.length - 1
      if tokens[i] == "(" and sost == 0
        sost = 1
        left = i
        count = count + 1
      elsif tokens[i] == ")" and (sost == 0 or count < 0)
        exeption = 2
      elsif tokens[i] == "(" and sost == 1
        count = count + 1
      elsif tokens[i] == ")" and sost == 1
        count = count - 1
        if count == 0
          right = i
          parts.push(tokens[(left + 1)..(right - 1)])
          sost = 0
        end

      end

    end
    if exeption != 0
      self.mistakes.push(exeption)
    end
    return parts
  end
end
