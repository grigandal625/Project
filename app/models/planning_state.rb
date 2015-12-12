class PlanningState < ActiveRecord::Base
  belongs_to :planning_session
  has_many :atoms, class_name: "StateBaseAtom"

  def skill
    atoms.skill
  end

  def knowledge
    atoms.knowledge
  end

  def psycho
    atoms.psycho
  end

  class TransitionDescriptor
    attr_accessor :from, :to
  end
end
