class Timetable < ActiveRecord::Base
  belongs_to :group
  has_many :events, dependent: :destroy
end
