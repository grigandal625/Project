class AddCognitiveStyleToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :included_figures_score, :float, :null => true
    add_column :students, :compare_similar_drawings_score, :integer, :null => true
    add_column :students, :compare_similar_drawings_time, :float, :null => true
    add_column :students, :free_sort_objects_dedicated_groups_count, :float, :null => true
    add_column :students, :free_sort_objects_largest_group_objects_count, :integer, :null => true
    add_column :students, :free_sort_objects_single_object_group_count, :float, :null => true
  end
end
