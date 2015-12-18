class AddDisableToKaQuestion < ActiveRecord::Migration
  def change
    add_column :ka_questions, :disable, :int, :null => false, :default => 0
  end
end
