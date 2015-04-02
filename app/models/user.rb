class User < ActiveRecord::Base
  belongs_to :student
  has_many :planning_sessions
end
