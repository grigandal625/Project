class TimetablesController < ApplicationController
  def index
    @groups = Group.all
    @event = Event.new
    @tips = Tip.all
    @works = Work.all
  end
end
