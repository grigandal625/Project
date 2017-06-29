#coding: utf-8
class OutrecsController < ActionController::Base

  def index
  end

  def show
  end


#    Student.where(group: @group).each do |student|
#      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
#                    "login" => student.user.login}
#    end
#  end

  def new
  end


def done
	Recomendation.find(params[:id]).update(done: true)
	redirect_to :back
end

def plan
	@student = Student.find(params[:s_id])
	print("--------////--------//Юхуууу//--------////--------")
	$plane = []
	time = Time.zone.now
	Recomendation.where( "(rec_status = ? OR date <= ?) AND student_id = ? AND done = ?", "ASSIGNED", time, params[:s_id], false).find_each do |rec| 
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = TestUtzQuestion.find(rec.rec_id).text
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	recd["type_um"] = rec.type_um
	recd["rec_id"] = rec.rec_id
	$plane.push(recd)	
end
end

  def create
  end

  def edit
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
  def update

  end

end
