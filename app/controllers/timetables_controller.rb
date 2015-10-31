class TimetablesController < ApplicationController
  def index
    @groups = Group.all
    @event = Event.new
  end
end
