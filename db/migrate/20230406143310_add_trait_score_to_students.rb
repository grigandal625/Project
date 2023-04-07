class AddTraitScoreToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :extra_introversion_score, :float, :null => true
    add_column :students, :emotional_excitability_score, :float, :null => true
  end
end
