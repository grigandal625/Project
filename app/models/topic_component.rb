class TopicComponent < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :component

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    super(options.merge(include: :component))
  end
end
