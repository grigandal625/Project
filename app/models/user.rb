class User < ActiveRecord::Base
  belongs_to :student
  has_many :planning_sessions
  has_many :planner_events
end
