#coding: utf-8
class PlanningTask < ActiveRecord::Base
    belongs_to :planning_session

    serialize :result, JSON
    serialize :params, JSON
end
