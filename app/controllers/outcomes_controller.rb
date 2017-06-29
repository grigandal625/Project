#coding: utf-8
class OutcomesController < AdminToolsController

  def index

    @groups = []
    Group.find_each do |group|
      @groups << {"number" => group.number,
                  "show_ref" => "<a href=\"#{outcome_path(group)}\">Просмотр</a>"}
    end
  end

  def show
    @group = Group.find(params[:id])
#    @students = []
    @results = []
    res = Hash.new
    @group.students.each do |student|
      fr_res = student.studentframes.last
      sem_res = student.semanticnetworks.last
      test_res = KaResult.where(user_id: student.user.id).last
	if sem_res.nil?  
		res["sem_res"] = "-"
        else
		res["sem_res"] = sem_res.rating
	end
	if fr_res.nil?  
		res["fr_res"] = "-"
        else
		res["fr_res"] = fr_res.result
	end
	if test_res.nil?  
		res["test_res"] = "-"
        else
		res["test_res"] = test_res.assessment
	end
        @results << {"fio" => "<a href=\"#{outcome_recomendations_path(@group, student)}\">#{student.fio}</a>", 
                    "sem_res" => res["sem_res"],
                    "fr_res" => res["fr_res"],
                    "test_res" => res["test_res"]}
      end
    end


#    Student.where(group: @group).each do |student|
#      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
#                    "login" => student.user.login}
#    end
#  end

  def new
  end

def recomendations

@student = Student.find(params[:s_id])
test_res = KaResult.where(user_id: @student.user.id).last
if !KaResult.where(user_id: @student.user.id).empty?
$problem = []
ProblemArea.where(ka_result_id: test_res.id).all.each do |prob|
	pr = Hash.new
	pr["k_id"]=prob.ka_topic_id
	pr["text"]=KaTopic.find(prob.ka_topic_id).text
	pr["mark"]=prob.mark.round(2)
	$problem.push(pr)
	end
end
$utzrecomendate=[]
if KaResult.where(user_id: @student.user.id).empty? 
print("--------////--------//Юхуууу//--------////--------")
else
if Recomendation.where(student_id: @student.id, type_um: "test_utz_question").empty? || (test_res.created_at > Recomendation.where(student_id: @student.id).last.updated_at)
	$problem.each do |prob|
		if prob["mark"] < 0.67
			TestUtzQuestion.where(ka_topic_id: prob["k_id"]).all.each do |a|
			Recomendation.create(student_id: params[:s_id], rec_id: a.id, rec_type: "utz", date: nil, done: false, rec_status: "CREATED", type_um: "test_utz_question")			
			end
		end
	end
Recomendation.where(student_id: @student.id, type_um: "test_utz_question").find_each do |rec|
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
	print("--------////--------//Юхуууу//--------////--------")
	print(recd["rec_id"])
	print("--------////--------//Юхуууу//--------////--------")
	$utzrecomendate.push(recd)
end
else
Recomendation.where(student_id: @student.id, done: false, type_um: "test_utz_question").find_each do |rec|
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
	$utzrecomendate.push(recd)	
end
end
end


$probrecomendate=[]
if Recomendation.where(student_id: @student.id, type_um: "prz").empty? || (test_res.created_at > Recomendation.where(student_id: @student.id).last.updated_at)
	$problem.each do |prob|
		if prob["mark"] < 0.67 
			Recomendation.create(student_id: params[:s_id], rec_id: prob["k_id"], rec_type: "know", date: nil, done: false, rec_status: "CREATED", type_um: "prz")
		end
	end
Recomendation.where(student_id: @student.id, type_um: "prz").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$probrecomendate.push(recd)
end
else
Recomendation.where(student_id: @student.id, done: false, type_um: "prz").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$probrecomendate.push(recd)	
end
end

$semrecomendate = []
#fr_res = @student.studentframes.last
sem_res = @student.semanticnetworks.last
#test_res = KaResult.where(user_id: @student.user.id).last
#Assigned(назначено), Deferred(отложено), 
if !@student.semanticnetworks.empty?
if Recomendation.where(student_id: @student.id, type_um: "s").empty? || (sem_res.created_at > Recomendation.where(student_id: @student.id).last.updated_at)
	if sem_res.rating < 90
		TopicComponent.where("component_id = ? AND ka_topic_id IS NOT NULL", 4 ).find_each do |top|
			Recomendation.create(student_id: params[:s_id], rec_id: top.ka_topic.id, rec_type: "know", date: nil, done: false, rec_status: "CREATED", type_um: "s")
		end
	end
Recomendation.where(student_id: @student.id, type_um: "s").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$semrecomendate.push(recd)
end
else 
Recomendation.where(student_id: @student.id, done: false, type_um: "s").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$semrecomendate.push(recd)	
end
end
end
$frmrecomendate = []
#@student = Student.find(params[:s_id])
frm_res = @student.studentframes.last
#sem_res = @student.semanticnetworks.last
#test_res = KaResult.where(user_id: @student.user.id).last
#Assigned(назначено), Deferred(отложено), 
if !@student.studentframes.empty?
if Recomendation.where(student_id: @student.id, type_um: "f").empty? || (frm_res.created_at > Recomendation.where(student_id: @student.id).last.updated_at)
	if frm_res.result.to_i < 90
		TopicComponent.where("component_id = ? AND ka_topic_id IS NOT NULL", 5 ).find_each do |top|
			Recomendation.create(student_id: params[:s_id], rec_id: top.ka_topic.id, rec_type: "know", date: nil, done: false, rec_status: "CREATED", type_um: "f")
		end
	end
Recomendation.where(student_id: @student.id, type_um: "f").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$frmrecomendate.push(recd)
end
else 
Recomendation.where(student_id: @student.id, done: false, type_um: "f").find_each do |rec|
	recd = Hash.new
	if rec.rec_type == "know"
		recd["text"] = KaTopic.find(rec.rec_id).text
	else 
		recd["text"] = Component.where(id: rec.rec_id).name
	end
	if rec.date.nil?
		recd["date"] = "-"
	else 
		recd["date"] = rec.date.strftime("%Y-%m-%d")
	end
	recd["id"] = rec.id
	recd["s_id"] = params[:s_id]
	$frmrecomendate.push(recd)	
end
end
end

end

def delrecomendation
	print("--------////--------")
	print(params[:s_id])
	print("--------////--------")
	print(params[:id])
	print("--------////--------")
	Recomendation.find(params[:id]).delete
#	$semrecomendate.delete_if{|o| o[:id] == params[:id].to_i}
#	redirect_to :back

#	Recomendation.find(params[:id]).delete
#	$frmsemrecomendate.delete_if{|o| o[:id] == params[:id].to_i}
	redirect_to :back
end

def changedate
	print("--------////--------")
	print(params[:date])
	$semrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: params[:date],rec_status: "DEFERRED")
	end

	$frmrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: params[:date],rec_status: "DEFERRED")
	end

	$probrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: params[:date],rec_status: "DEFERRED")
	end

	$utzrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: params[:date],rec_status: "DEFERRED")
	end
	print("--------////--------")
	redirect_to :back
end

def assign
	$semrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
	end

	$frmrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
	end

	$probrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
	end
	$utzrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
	end
	redirect_to :back
end

def cancel
	$semrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
	end

	$frmrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
	end

	$probrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
	end
	$utzrecomendate.each do |rec|
		Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
	end
	redirect_to :back
end


##______________________________________________________________________________________##
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
def create
  end

  def edit
  end
end
