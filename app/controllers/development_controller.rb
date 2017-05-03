class DevelopmentController < ApplicationController
  include PlanningHelper

  def self.create_extension
    ext = ExtensionDatabase::ATExtension.new
    ext.ext_type = ExtensionDatabase::ExtensionType::Other
    ext.description = "Компонент разработки обучающих воздействий"
    ext.tasks = ["training-impact-development-step"]

    ext.generate_state = lambda { |mode_id, week_id, schedule, state|
      atom = StateFacts.create(
          task_name: "training-impact-development-step",
          state: 1)
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Разработка обучающих воздействий"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if((pddl_act == "execute-development-step") && (leaf_id == "training-impact-development-step"))
        return {"controller" => "development", "params" => {}}
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
    @students = Student.all.count
    @tasks = Task.all.count
    @etalons = Etalon.all.count
    @etalonframes = Etalonframe.all.count
  end
end
