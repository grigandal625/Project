class CreatePersonalityTraitIntervals < ActiveRecord::Migration
  def change
    create_table :personality_trait_intervals do |t|
      t.float :begin_at
      t.float :end_at
      t.references :personality, index: true
      t.references :personality_trait, index: true

      t.timestamps
    end

    Personality.all.each do |p|
      PersonalityTraitInterval.create begin_at: p.begin_at, end_at: p.end_at,
                                      personality_id: p.id, personality_trait_id: p.personality_trait_id
    end
  end
end
