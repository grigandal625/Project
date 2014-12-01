class AddOrderToPersonalityTestQuestions < ActiveRecord::Migration
  def change
    add_column :personality_test_questions, :ordering, :integer
  end
end
