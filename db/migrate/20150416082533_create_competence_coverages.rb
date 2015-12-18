class CreateCompetenceCoverages < ActiveRecord::Migration
  def change
    create_table :competence_coverages, id: false do |t|
      t.references :ka_result,     index: true
      t.references :competence,    index: true
      t.float :mark,               null: false,  default: 0

      t.timestamps
    end
  end
end
