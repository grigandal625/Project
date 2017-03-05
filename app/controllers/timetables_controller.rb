class TimetablesController < ApplicationController
  include PlanningHelper
  skip_before_filter :verify_authenticity_token

  def self.create_extension
    ext = ExtensionDatabase::ATExtension.new
    ext.ext_type = ExtensionDatabase::ExtensionType::Other
    ext.description = "Компонент составления расписаний"
    ext.tasks = ["timetables-development-step"]

    ext.generate_state = lambda { |mode_id, week_id, schedule, state|
      atom = StateFacts.create(
          task_name: "timetables-development-step",
          state: 1)
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Составление расписаний"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if((pddl_act == "execute-development-step") && (leaf_id == "timetables-development-step"))
        return {"controller" => "timetables", "params" => {}}
      else
        return {}
      end
    }

    return ext
  end

  def execute
    session[:planning_task_id] = params[:planning_task_id]
    redirect_to action: "index"
  end

  def commit
    task = PlanningTask.find(session[:planning_task_id])
    transition = PlanningState::TransitionDescriptor.new
    transition.from = 1
    transition.to = 3
    task.state_atom.transit_to transition
    current_planning_session().commit_task(task)
    session[:planning_task_id] = nil

    redirect_to "/"
  end

  def index
    if params[:month] != nil
      @date = Date.parse params[:month]
    else
      @date = Date.today
    end
    @user = User.find_by(id: session[:user_id])
    @event = Event.new
    @timetables = Timetable.all
    @timetables_showed = []
    show = session[:show]
    if show != nil
      @timetables_showed = Timetable.where(id: show.select{|k,v| v == '1'}.keys)
    end
    if @user.role == 'student'
      @timetables_showed = Timetable.find_by(group_id: Student.find(@user.student_id).group_id)
    end
    @template = TimetableTemplate.new
    @templates = TimetableTemplate.all
    if (session[:planning_task_id]!=nil)
      @task = PlanningTask.find(session[:planning_task_id])
    end
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
    if params[:month] != nil
      @date = Date.parse params[:month][:month]
    else
      @date = Date.today
    end
    show = params[:show]
    session[:show] = show
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
    if params[:month] != nil
      @date = Date.parse params[:month][:month]
    else
      @date = Date.today
    end
    @timetable = Timetable.find(params[:id])
    @timetable.events.each do |event|
      event.destroy
    end
    @timetable = Timetable.find(params[:id])
    if params[:json]!=''
      json = JSON.parse(params[:json])
      (0..json.length-1).each do |i|
        event = @timetable.events.new
        event.action = json[i]['action']
        event.task = json[i]['task']
        event.name =  json[i]['name']
        event.date = json[i]['date']
        if json[i]['only_time'] != nil
          event.only_time = Time.parse json[i]['only_time']
        end
        event.save
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
