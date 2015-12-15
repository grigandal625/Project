#coding: utf-8
class PlanningTask < ActiveRecord::Base
    belongs_to :planning_session
    belongs_to :state_atom, class_name: "StateBaseAtom"

    serialize :result, JSON
    serialize :params, JSON
end
