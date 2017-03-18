class PersonalityTest < ActiveRecord::Base
  has_many                  :personality_test_questions,      dependent: :destroy
  belongs_to                :personality_test_type
  has_and_belongs_to_many   :students
  accepts_nested_attributes_for :personality_test_questions

  validates :name, presence: true
  validates :personality_test_type, presence: true

  def questions
    personality_test_questions
  end

  def type
    personality_test_type
  end
end
