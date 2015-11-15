class Hierarchy2 < ActiveRecord::Migration
  def self.up
    w3 = Work.create(:title => "work3", :tip_id => 1, :description => "durak")
    w4 = Work.create(:title => "work4", :tip_id => 2, :description => "idiot")
  end
end
