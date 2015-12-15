class AddDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :action, :string
    add_column :events, :task, :string
  end
end
