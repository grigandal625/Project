# def _combinations(attributes, callback=nil)
#   return [{}] if attributes.empty?
#   first_attr, *rest_attrs = attributes
#   rest_combinations = _combinations(rest_attrs)

#   first_attr_values = first_attr.last
#   first_attr_values.flat_map do |value|
#     rest_combinations.map do |combination|
#       res = { "#{first_attr.first}": value, **combination }
#       callback.nil? ? res : callback.call(**res)
#     end
#   end
# end

# def combinations(attrs, callback=nil)
#   attributes = attrs.keys.map do |key|
#     res = [key, attrs[key]]
#     key = res
#   end
#   return _combinations(attributes, callback)
# end

# a = { h: [1, 2], x: [3, 4] }

# def s(h:, x:)
#   h + x
# end

# print combinations(a, method(:s))

module ModuleA
  def self.methodA
    puts "Method A from Module A"
  end
end

module ModuleB
  def self.methodA
    puts "Method A from Module B"
  end
end

class MyClass
  include ModuleA
  include ModuleB
  
  def my_method
    # вызываем метод methodA из ModuleA
    ModuleA::methodA
    
    # вызываем метод methodA из ModuleB
    ModuleB::methodA
  end
end

my_object = MyClass.new
my_object.my_method