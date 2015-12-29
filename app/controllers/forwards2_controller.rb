#coding: utf-8
class Forwards2Controller < ApplicationController
  include PlanningHelper
  skip_before_filter :verify_authenticity_token

  def index

  end

    def self.create_extension
        ext = ExtensionDatabase::ATExtension.new
        ext.ext_type = ExtensionDatabase::ExtensionType::Skill
        ext.description = "Компонент выявления уровня умений выявлять причины"
        ext.tasks = ["reasoning-skill"]

        ext.generate_state = lambda { |mode_id, week_id, schedule, state|
                                atom = StateSkill.create(state: 1,
                                                         ext_name: "reasoning",
                                                         action_name: "extract-skill",
                                                         task_name: "reasoning-skill")
                                state.atoms.push << atom
                            }

        ext.task_description = lambda { |leaf_id|
                    return "Выявить уровень умений выявлять причины"
                }

        ext.task_exec_path = lambda { |pddl_act, leaf_id|
                    if((pddl_act == "extract-skill") && (leaf_id == "reasoning-skill"))
                        return {"controller" => "forwards2", "params" => {}}
                    else
                        return {}
                    end
                }

        return ext
    end

    def execute
        session["planning_task_id"] = params[:planning_task_id]
        redirect_to :action => "index"
    end

    def commit
        task = PlanningTask.find(params["planning_task_id"])
        transition = PlanningState::TransitionDescriptor.new
        transition.from = 1
        transition.to = 3
        task.state_atom.transit_to transition
        #task.result = {:delete => {"pending-skills" => "reasoning-skill"}}
        current_planning_session().commit_task(task)

        redirect_to "/"
    end
# def getfile
#   time = Time.now.utc.to_i 
#   Dir.mkdir('public/uploads/JSON/forward/'+params[:id]) unless File.exists?('public/uploads/JSON/forward/'+params[:id])
#   f = File.open('public/uploads/JSON/forward/'+params[:id]+'/'+time.to_s+'.json', 'w+')
#   f.puts(params[:trace])
#   f.close()
#   if params[:end]=='no' 
#  @results = Result.new()
#  @results.action = 'forward'
#  @results.user = User.find(params[:id])
#  @results.startfile = time.to_s+'.json'
#  @results.timebegin = time
#  @results.save()
#  render :text => "Конфигурация сохранена"
#   else
# @results = Result.where('user_id='+params[:id]).order('id DESC').only(:order, :where).limit(1).take!

#  @results.timeend = time
#  @results.endfile = time.to_s+'.json'
#  @results.result = params[:e]
#  @results.save()
#  render :text => "Тестирование закончено"
#  end
  def saveResult
    @user = User.find (session["user_id"])
    date = Time.now.to_formatted_s(:short)
    result = Fbresult.new
    result.fio = @user.student.fio
    result.fb = "Прямой"
    result.result = params[:result]
    result.group = @user.student.group.number
    result.save
  end
  def results
    @results = Fbresult.find(:all)
  end

end
