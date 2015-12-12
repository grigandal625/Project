#coding: utf-8
class DummyController < ApplicationController
    include PlanningHelper
    
    def self.create_extension
        ext = ExtensionDatabase::ATExtension.new
        ext.ext_type = ExtensionDatabase::ExtensionType::Skill
        ext.description = "Компонент выявления уровня умений моделировать простейшие ситуации с помощью фреймов"
        ext.tasks = ["frame-skill"]

        ext.generate_state = lambda { |mode_id, week_id, schedule, state|
                                atom = StateSkill.create(
                                                         ext_name: "dummy",
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
                        return {"controller" => "dummy", "params" => {}}
                    else
                        return {}
                    end
                }

        return ext
    end

    def execute
        redirect_to :action => "index", :planning_task_id => params["planning_task_id"]
    end

    #Current planning task ID should be stored somewhere in the session/database/user info
    #It can always be retrieved with current_planning_session().current_task() 
    def index
        @task = PlanningTask.find(params["planning_task_id"])
    end

    def commit
        task = PlanningTask.find(params["planning_task_id"])
        transition = PlanningState::TransitionDescriptor.new
        transition.from = 1
        transition.to = 3
        task.state_atom.transit_to transition
        current_planning_session().commit_task(task)

        redirect_to "/"
    end
end
