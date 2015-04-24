class DummyController < ApplicationController
    include PlanningHelper
    
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
        task.result = {:delete => {"pending-skills" => "frame-skill"}}
        current_planning_session().commit_task(task)

        redirect_to "/"
    end
end
