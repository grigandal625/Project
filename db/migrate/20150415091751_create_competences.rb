class CreateCompetences < ActiveRecord::Migration
  def change
    create_table :competences do |t|
      t.string :code,			    null: false, default: ""
      t.string :description,	null: false, default: ""

      t.timestamps
    end
  end
end
