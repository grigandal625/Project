#coding: utf-8
class ForwardsController < ApplicationController
     include PlanningHelper



  def index
      # @task = PlanningTask.find(params["planning_task_id"])
     
  end
  
   
    
    def execute
        redirect_to :action => "index", :planning_task_id => params["planning_task_id"]
    end

    
    def commit
        task = PlanningTask.find(params["planning_task_id"])
        #task.result = {:delete => {"pending-skills" => "reasoning-skill"}}
        current_planning_session().commit_task(task)

        redirect_to "/"
    end
    
end
