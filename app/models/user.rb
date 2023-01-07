class User < ActiveRecord::Base
  belongs_to :student
  has_many :planning_sessions
  has_many :planner_events
  has_many :ka_results, inverse_of: 'user'
end
