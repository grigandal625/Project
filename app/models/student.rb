class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results
  has_one :user
end
