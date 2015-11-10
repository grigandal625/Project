class TimetablesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    @event = Event.new
    @timetables = Timetable.all
    @template = TimetableTemplate.new
    @templates = TimetableTemplate.all
  end
  def init #if group haven't timetable => creates timetable
    @groups = Group.all
    @count = 0
    @groups.each do |group|
      if group.timetable==nil
        timetable = Timetable.new
        timetable.group_number = group.number
        group.timetable = timetable
        @count+= 1
      end
    end
    respond_to do |format|
      format.js
    end
  end
  def show #shows checked timetables
    show = params[:show]
    @timetables = Timetable.where(id: show.select{|k,v| v == '1'}.keys)
    respond_to do |format|
      format.js
    end
  end
  def to_json #shows timetable events in to_json_form textarea
    @timetable = Timetable.find(params[:id])
    @events = @timetable.events
    @json = []
    @events.each do |event|
      @json << JSON[event.to_json]
    end
    respond_to do |format|
      format.js
    end
  end
  def paste #paste template json in from_json_form textarea
    @template = TimetableTemplate.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  def from_json #destroy all events of chosen timetable and creates new from json in from_json_form textarea
    @timetable = Timetable.find(params[:id])
    @timetable.events.each do |event|
      event.destroy
    end
    @timetable = Timetable.find(params[:id])
    if params[:json]!=''
      json = JSON.parse(params[:json])
      (0..json.length-1).each do |i|
        event = @timetable.events.new
        event.test_id = json[i]['test_id']
        event.week = json[i]['week']
        event.save
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
