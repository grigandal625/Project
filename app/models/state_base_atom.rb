class StateBaseAtom < ActiveRecord::Base
  belongs_to :planning_state

  States = {1 => :pending, 2 => :low_level, 3 => :satisfactory_level}

  scope :skill, -> {where(type: "StateSkill")}
  scope :knowledge, -> {where(type: "StateKnowledge")}
  scope :psycho, -> {where(type: "StatePsycho")}

  def transit_to(transition_descriptor)
    from = transition_descriptor.from
    to = transition_descriptor.to

    p from
    p to

    update_attribute :state, to # TODO logic, see StateSkill, StateKnowledge, StatePsycho
  end

end
