#coding: utf-8
class Framedb < ActiveRecord::Base

  def  self.create_frame(name, code)
    if not is_frame_with_name(name)
      frame = Framedb.new()

    else
      frame = Framedb.where(:name => name)[0]
    end
    frame.name = name
    frame.code = code
    frame.save()
  end

  def self.is_frame_with_name(name)
    frame = Framedb.where(:name => name)
    if frame.length > 0
      return true
    end
    return false
  end

  def self.get_frame_from_name(name)
    frame = Framedb.where(:name => name)
    if frame.length > 0
      return frame[0]
    end
    return nil
  end


end
