def print_group_topics(group, number)
    puts "Группа #{number}:"
    group.each do |topic|
        puts topic.text
    end
end

def print_groups_topics(groups)
    i = 0
    puts "Количество групп: #{groups.count}"
    groups.each do |group|
        print_group_topics(group, i)
        i +=1
    end
end

def print_triad_topics(triad, number)
    puts "Триада #{number}:"
    triad.each do |topic|
        puts topic.text
    end
end

def print_triades_topics(triades)
    i = 0
    puts "Количество триад: #{triades.count}"
    triades.each do |triad|
        print_triad_topics(triad, i)
        i +=1
    end
end

groups = KaTopic.get_groups(2)
triades = KaTopic.formate_triades(groups)

#print_group_topics(groups[0], 0)
#print_triad_topics(triades[0], 0)
print_groups_topics(groups)
print_triades_topics(triades)

#puts "Количество вершин: #{KaTopic.find(1).get_tree.count}"

# def print_topic_constructs(topic)
#     puts "Тема #{topic.text}:"
#     topic.constructs.sort.each do |value|
#         puts value.id
#     end
# end

# def print_topic2_constructs(topic)
#     puts "Тема #{topic.text}:"
#     topic.topic_constructs.sort{|a, b| a.construct_id <=> b.construct_id}.each do |value|
#         puts value["construct_id"]
#     end
# end

# top_a = KaTopic.find(909)
# top_b = KaTopic.find(914)
#print_topic2_constructs(top_a)
#print_topic2_constructs(top_b)

# def get_root
#     root = self
#     while !root.parent_id.nil? do
#       root = KaTopic.parent
#     end
#     return root
#   end
# end
