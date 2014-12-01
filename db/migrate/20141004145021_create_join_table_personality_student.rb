class CreateJoinTablePersonalityStudent < ActiveRecord::Migration
  def change
    create_join_table :personalities, :students do |t|
      # t.index [:personality_id, :student_id]
      # t.index [:student_id, :personality_id]
    end
  end
end
