class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :number

    end
  end
end
