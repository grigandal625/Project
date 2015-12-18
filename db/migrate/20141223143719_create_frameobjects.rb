class CreateFrameobjects < ActiveRecord::Migration
  def change
    create_table :frameobjects do |t|

      t.timestamps
    end
  end
end
