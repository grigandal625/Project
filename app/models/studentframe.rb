class Studentframe < ActiveRecord::Base
  belongs_to :etalonframe
  belongs_to :student
end
