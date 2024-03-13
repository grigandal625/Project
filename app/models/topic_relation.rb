class TopicRelation < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :related_topic, class_name: "KaTopic"

  def self.calculate_relation(top_a, top_b)
    values_a = top_a.topic_constructs.sort{|a, b| a.construct_id <=> b.construct_id}
    values_b = top_b.topic_constructs.sort{|a, b| a.construct_id <=> b.construct_id}
    if top_a.id != top_b.id and values_a.map{|c| c.construct_id} == values_b.map{|c| c.construct_id} and values_a.count != 0

      sum = 0
      for i in 0...values_a.count
        sum += (values_a[i].mark - values_b[i].mark).abs ** 2
      end
      sum = Math.sqrt(sum / values_a.count) / 100

      #rel = TopicRelation.new(ka_topic_id: top_a.id, related_topic_id: top_b.id)
      a = top_a.parent_id.nil?
      root = top_a.get_root
      rel = TopicRelation.new(ka_topic_id: top_a.id, related_topic_id: top_b.id, root_topic_id: root.id)
      if sum < 0.3
        rel[:rel_type] = 0
      elsif sum < 0.7
        rel[:rel_type] = 1
      else
        rel[:rel_type] = 2
      end
      return rel
    end
    return nil
  end

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    super(options.merge(include: [:ka_topic, :related_topic]))
  end
end
