#coding: utf-8
class Frameobject
  attr_accessor :parents
  attr_accessor :name
  attr_accessor :type
  attr_accessor :children

  def initialize(name, type, children)
    @name = name
    @type = type
    @children = children
  end


  def freme_data
    frame_data ||=
        {
            name: @name,
            type: @type,
            children: @children
        }
  end

  def findobject (name)
    if self.name == name
      return self
    end
    for i in 0..children.length - 1
      if self.children[i].findobject(name)
        return self.children[i].findobject(name)
      end
    end
    return nil
  end


  def globalfind (name)
    if self.name == name and self.type == "frame"
      return self
    end
    for i in 0..children.length - 1
      if self.children[i].globalfind(name)
        return self.children[i].globalfind(name)
      end
    end
    return nil
  end

  def add( object)
    self.children.push(object)
  end
end
