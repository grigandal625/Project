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

    def planning_event_text(type_id)
        case type_id
        when 0
            "Plan Generated"
        when 1
            "Session Started"
        when 2
            "Session Ended"
        when 3
            "Task Started"
        when 4
            "Task Ended"
        else
            "Unkown Event"
        end
    end

    def get_planning_log
        events = PlannerEvent.last(20)

        res = []

        events.each do |ev|
            res.push({"created_at" => ev.created_at, "event" => planning_event_text(ev.type_id), "user" => ev.user.login, "descr" => ev.description})
        end

        return res
    end
end
