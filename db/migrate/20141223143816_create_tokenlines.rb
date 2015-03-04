class CreateTokenlines < ActiveRecord::Migration
  def change
    create_table :tokenlines do |t|

      t.timestamps
    end
  end
end
