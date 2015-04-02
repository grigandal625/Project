module PlanningHelper
    def current_planning_session
       return PlanningSession.where(:user => @user, :closed => 0).take
    end

    def current_planning_task
        pses = current_planning_session()
        if(pses != nil)
            task = PlanningTask.where(:planning_session => pses, :closed => 0).take
            return task
        else
            return nil
        end
    end
end
