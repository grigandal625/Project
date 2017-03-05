class ScheduleController < ApplicationController

  def index
    user = User.find_by(id: session[:user_id])
    if @user.role == 'student'
      @events = Timetable.find_by(group_id: Student.find(@user.student_id).group_id).events
    else
      @events = Event.all
    end
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end

end
