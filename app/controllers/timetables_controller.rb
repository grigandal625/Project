class TimetablesController < ApplicationController
  def index
    @groups = Group.all
    @event = Event.new
    @timetables = Timetable.all
  end
  def add
    @timetables = Timetable.all
    @show = params[:show]
    respond_to do |format|
      format.js
    end
  end
end
