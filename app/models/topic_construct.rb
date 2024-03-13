class TopicConstruct < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :construct

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    super(options.merge(include: :construct))
  end
end
