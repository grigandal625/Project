class CreateRecomendations < ActiveRecord::Migration[5.0]
  def change
    create_table :recomendations do |t|
	t.references :student, index: true
        t.integer :rec_id
	t.text :rec_type
	t.datetime :date
	t.boolean :done

        t.timestamps
    end
  end
end
