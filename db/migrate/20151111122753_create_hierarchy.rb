class CreateHierarchy < ActiveRecord::Migration
  def self.up
    t1 = Tip.create(:name => "Психотест")
    t2 = Tip.create(:name => "Знания")
    t3 = Tip.create(:name => "Умения")
   
    w1 = Work.create(:title => "Психотест", :tip_id => t1.id, :description => "1")
    w2 = Work.create(:title => "Семантические сети", :tip_id => t3.id, :description => "2")
    w3 = Work.create(:title => "Фреймы", :tip_id => t3.id, :description => "2")
    w4 = Work.create(:title => "Прямой обратный вывод", :tip_id => t3.id, :description => "3")
    w5 = Work.create(:title => "V, G, S", :tip_id => t3.id, :description => "5")
    k1 = KaTest.create(:id => 1, :text =>"qwe")
    k2 = KaTest.create(:id => 2, :text =>"rty")
  end
end
