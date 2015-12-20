class TimetablesController < ApplicationController
  def index
    @groups = Group.all
    @event = Event.new
    @tips = Tip.all
    @works = Work.all
  end
 
    def get_works
    @w_old = Work.all
    @w_old = @w_old.where("tip_id = '2'")
    @w_old.destroy_all
    @ka_tests = KaTest.all
    @ka_tests.each do |a|
      Work.create(:title => a.text, :tip_id => 2, :description => "loh")
    end
    redirect_to timetables_path
    end    
end
