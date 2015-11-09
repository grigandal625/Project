class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_events, only: [:move, :edit, :update, :destroy]
  def new
    @event  = Event.new
    @timetable_id = params[:timetable_id]
    @week = params[:week]
    respond_to do |format|
      format.js
    end
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
    @event.week = params[:week]
    @event.timetable_id = params[:timetable_id]
    @event.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @event.update_attributes(event_params)
  end

  def destroy
    if @event.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private

    def set_events
      @event = Event.find(params[:id])
    end
    def event_params
      params.require(:event).permit(:test_id, :name, :week, :timetable_id)
    end
end
