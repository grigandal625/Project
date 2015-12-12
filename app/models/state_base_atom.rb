class StateBaseAtom < ActiveRecord::Base
  belongs_to :planning_state

  States = {1 => :pending, 2 => :low_level, 3 => :satisfactory_level}

  def get_state
    state
  end

  def transit_to(transition_descriptor)
    from = transition_descriptor.from
    to = transition_descriptor.to

    return if (from != state)

    state = to # TODO logic, see StateSkill, StateKnowledge, StatePsycho
  end

  protected
  def state
    self[:state]
  end

  def state=(val)
    write_attribute :state, val
  end
end
