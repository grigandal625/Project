class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results
  has_many :semanticnetworks
  has_many :studentframes

  has_one :user, dependent: :destroy
end
