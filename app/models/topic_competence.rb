class TopicCompetence < ActiveRecord::Base
  belongs_to :competence
  belongs_to :ka_topic

  def serializable_hash(options={})
    if options.nil? 
      options = {}
    end
    super(options.merge(include: :competence))
  end

end
