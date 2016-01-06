#coding: utf-8
class FramestudentController <  ApplicationController
skip_before_filter :verify_authenticity_token
include PlanningHelper

    def self.create_extension
        ext = ExtensionDatabase::ATExtension.new
        ext.ext_type = ExtensionDatabase::ExtensionType::Skill
        ext.description = "Компонент выявления уровня умений моделировать ситуации с помощью фреймов"
        ext.tasks = ["frame-skill"]

        ext.generate_state = lambda { |mode_id, week_id, schedule, state|
                                atom = StateSkill.create(
                                                         ext_name: "framestudent",
                                                         action_name: "extract-skill",
                                                         task_name: "frame-skill",
                                                         state: 1)
                                state.atoms.push << atom
                            }

        ext.task_description = lambda { |leaf_id|
                    return "Выявить уровень умений моделировать ситуации с помощью фреймов"
                }

        ext.task_exec_path = lambda { |pddl_act, leaf_id|
                    if((pddl_act == "extract-skill") && (leaf_id == "frame-skill"))
                        return {"controller" => "framestudent", "params" => {}}
                    else
                        return {}
                    end
                }

        return ext
    end

  def index

  end

def execute
  session["planning_task_id"] = params[:planning_task_id]
  #createstudentframe
  redirect_to :action => "index"

end

  def show
    @studentframe = Studentframe.find(params[:id])
    @framestudentcode = Frame.new
    @framestudentcode.inic(@studentframe.studentcode)
    @framestudentcode.createframe(@studentframe.studentcode)
    @mytime = Time.now
  end

  def createstudentframe
    @studentframe = Studentframe.new
    @studentframe.result = 0
    @studentframe.student = @user.student
    @studentframe.etalonframe = Etalonframe.offset(rand(Etalonframe.count)).first
    @studentframe.mistakes = ""
    @studentframe.isfinish = false
    @studentframe.studentcode = @studentframe.etalonframe.studentcode
    @studentframe.created_at= Time.now
    @studentframe.save



    redirect_to framestudent_path(@studentframe.id)
  end

  def destroy
    Studentframe.find(params[:id]).destroy
    redirect_to :back
  end


  def updateframe
    if (params[:studentcode].size < 2500) #Ограничение для невозможноси передачи флуда


      frame = Studentframe.find(params[:id])
      frame.studentcode = params[:studentcode]
      framestudentcode = Frame.new
      framestudentcode.inic(params[:studentcode])
      framestudentcode.createframe(params[:studentcode])

      ecode = Frame.new
      ecode.inic(frame.etalonframe.framecode)
      ecode.createframe(frame.etalonframe.framecode)
      frame.mistakes = "Ошибки в фрейме: "  + framestudentcode.mistakes.to_s

      if params[:commit]  == "Завершить"
        @solver = FrameSolver.new
        @solver.inic(framestudentcode,ecode )
        @solver.differentnames

        frame.studentmistakes = @solver.mistakes.to_s
        frame.kbstudentmistakes = @solver.getstring
        frame.result =  (100 + @solver.result)


        frame.isfinish = true

        task = PlanningTask.find(session[:planning_task_id])
        transition = PlanningState::TransitionDescriptor.new
        transition.from = 1
        if frame.result < 50
          transition.to = 2
        else
          transition.to = 3
        end
        task.state_atom.transit_to transition
        #task.result = {:delete => {"pending-skills" => "frame-skill"}}
        current_planning_session().commit_task(task)



      end
    if frame.result.to_i < 0
      frame.result = "0"
    end
      frame.save
    end
    redirect_to :back
  end
end
