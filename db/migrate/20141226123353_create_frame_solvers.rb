class CreateFrameSolvers < ActiveRecord::Migration
  def change
    create_table :frame_solvers do |t|

      t.timestamps
    end
  end
end
