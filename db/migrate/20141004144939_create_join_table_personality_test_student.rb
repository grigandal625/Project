class CreateJoinTablePersonalityTestStudent < ActiveRecord::Migration
  def change
    create_join_table :personality_tests, :students do |t|
      # t.index [:personality_test_id, :student_id]
      # t.index [:student_id, :personality_test_id]
    end
  end
end
