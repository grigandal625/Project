class CreateHierarchy < ActiveRecord::Migration
  def self.up
    t1 = Tip.create(:name => "tip1")
    t2 = Tip.create(:name => "tip2")
   
    w1 = Work.create(:title => "work1", :tip_id => t1.id, :description => "loh")
    w2 = Work.create(:title => "work2", :tip_id => t2.id, :description => "dibil")
  end
end
