class ScheduleController < ApplicationController
	def index
		@schedules = Schedule.all
	end

	def show
		@schedule = Schedule.find(params[:id])
	end
end
