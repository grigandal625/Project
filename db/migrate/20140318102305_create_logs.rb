class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :result
      t.text :data
      t.references :component, polymorphic: true, index: true
    end
  end
end
