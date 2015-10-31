class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def new

  end

  def create
    @event  = Event.new(event_params)
    if @event.save
      respond_to do |format|
        format.js
      end
    end
  end

  def move
    @event = Event.find(params[:id])
    @event.week = params[:week]
    @event.timetable_id = params[:timetable_id]
    @event.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      respond_to do |format|
        format.js
      end
    end
  end

    private
    def event_params
      params.require(:event).permit(:test_id, :name, :week, :timetable_id)
    end
end
