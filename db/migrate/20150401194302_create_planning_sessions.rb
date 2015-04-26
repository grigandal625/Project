class CreatePlanningSessions < ActiveRecord::Migration
  def change
    create_table :planning_sessions do |t|
        t.references :user
        t.integer :closed, :default => 0
        t.string :state
        t.string :plan
        t.string :procedure
        t.timestamps
    end
  end
end
