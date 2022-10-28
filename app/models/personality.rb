class Personality < ActiveRecord::Base
  has_many :personality_traits, through: :personality_trait_intervals
  has_many :personality_trait_intervals
  has_and_belongs_to_many :students

  def traits
    personality_traits
  end

  def intervals
    personality_trait_intervals
  end
end
