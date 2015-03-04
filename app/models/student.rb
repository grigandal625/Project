class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results
  has_many :semanticnetworks
  has_one :user, dependent: :destroy
  has_and_belongs_to_many :passed_personality_tests, class_name: 'PersonalityTest'
  has_and_belongs_to_many :personalities

end
