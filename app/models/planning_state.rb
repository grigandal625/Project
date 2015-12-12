class PlanningState < ActiveRecord::Base
  belongs_to :planning_session
  has_many :atoms, class_name: "StateBaseAtom"

  class TransitionDescriptor
    attr_accessor :from, :to
  end
end
