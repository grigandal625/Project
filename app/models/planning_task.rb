class PlanningTask < ActiveRecord::Base
    belongs_to :planning_session

    serialize :result, JSON
end
