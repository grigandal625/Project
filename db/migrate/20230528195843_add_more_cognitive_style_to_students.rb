class AddMoreCognitiveStyleToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :equivalence_range_score, :integer, :null => true
    add_column :students, :field_independence_dependency_score, :integer, :null => true
    add_column :students, :impulsivity_reflexivity_score, :integer, :null => true
  end
end
