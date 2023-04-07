KaTopic.all.each do |topic|
    topic._children.each do |child|
        child.parent = topic
        child.save!
    end
end