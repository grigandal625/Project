class CreateProblemAreas < ActiveRecord::Migration
  def change
    create_table :problem_areas, id: false do |t|
      t.references :ka_result, index: true
      t.references :ka_topic,  index: true
      t.float :mark,      null: false,  default: 0

      t.timestamps
    end
  end
end
