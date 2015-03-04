class PersonalityTrait < ActiveRecord::Base
  has_many :personalities, through: :personality_trait_intervals
  has_many :personality_trait_intervals

  def intervals
    personality_trait_intervals
  end
end
