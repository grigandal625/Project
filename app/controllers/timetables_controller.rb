class TimetablesController < ApplicationController
  skip_before_filter :verify_authenticity_token
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
  def to_json
    @timetable = Timetable.find(params[:id])
    @events = @timetable.events
    respond_to do |format|
      format.js
    end
  end
  def from_json
    @timetable = Timetable.find(params[:id])
    @timetable.events.each do |event|
      event.destroy
    end
    if params[:json]!=''
      json = JSON.parse(params[:json])
      (0..json.length-1).each do |i|
        event = @timetable.events.new
        event.test_id = json[i]["test_id"]
        event.week = json[i]["week"]
        event.save
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
