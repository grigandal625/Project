class TestUtzTopic < ApplicationRecord
  belongs_to :test_utz_question
  belongs_to :ka_topic
  belongs_to :matching_utz
  belongs_to :filling_utz
  belongs_to :text_correction_utz
  belongs_to :images_sort_utz
  belongs_to :likert_utz
  belongs_to :hierarchy_utz

  def self.ett_list
    return [TestUtzQuestion, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, LikertUtz, HierarchyUtz]
  end

  def self.utz_list
    return [TestUtzQuestion, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, LikertUtz, HierarchyUtz]
  end

  def self.ett_types_mapping
    res = {}
    TestUtzTopic.ett_list.each do |ett_class|
      res[ett_class.name.demodulize.underscore.to_sym] = {
        model: ett_class,
        label: ett_class.label,
      }
    end
    return res
  end

  def ett_list
    return TestUtzTopic.ett_list
  end

  def ett_types_mapping
    return TestUtzTopic.ett_types_mapping
  end

  def utz
    ett_types_mapping.keys.each do |key|
      if !send(key.to_s).nil?
        return send(key.to_s)
      end
    end
    return nil
  end

  def utz_type
    ett_types_mapping.keys.each do |key|
      if !send(key.to_s).nil?
        return key.to_s
      end
    end
    return nil
  end

  def utz_type_label
    return self.utz_type.nil? ? "-" : self.ett_types_mapping[self.utz_type.to_sym][:label]
  end

  def ett_type
    return self.utz_type
  end

  def ett_type_label
    return self.utz_type_label
  end

  def utz=(v)
    if v.nil?
      ett_types_mapping.keys.each do |key|
        assign_attributes({ "#{key.to_s}" => nil })
        return nil
      end
    else
      ett_types_mapping.keys.each do |key|
        if v.is_a?(ett_types_mapping[key][:model])
          attrs = { "#{self.utz_type}" => nil, "#{key.to_s}" => v }
          puts attrs
          assign_attributes(attrs)      
          return v
        end
      end
    end
  end

  def ett
    return self.utz
  end

  def ett=(v)
    self.utz = v
  end
end
