class Personality < ActiveRecord::Base
  belongs_to :personality_trait

  def trait
    personality_trait
  end
end
