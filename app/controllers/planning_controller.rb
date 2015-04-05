class PlanningController < ApplicationController
    include PlanningHelper

    def index
        @psession = current_planning_session()
        @cur_task = @psession ? @psession.current_task() : nil

        if(@user.role == 'admin')
            @events = PlannerEvent.last(20)
        end
    end
    
    def new_session
        case params[:procedure]
        when "tutor_designtime_initial"
            if(@user.role != 'admin')
                throw "Invalid user role"
            end

            ps = PlanningSession.create(:user => @user, :closed => 0, :state => [], :procedure => "tutor_designtime_initial")
            ps.generate_plan()
            redirect_to action: "index"
        when "tutor_runtime"
            if(@user.role == 'admin')
                throw "Invalid user role"
            end

            ps = PlanningSession.create(:user => @user, :closed => 0, :state => {"pending-skills" => ["frame-skill", "sem-network-skill", "linguistic-skill", "reasoning-skill"], "pending-knowledge" => [23, 41, 12], "low-knowledge" => [], "pending-tutoring" => []}, :procedure => "tutor_runtime")
            ps.generate_plan()
            redirect_to action: "index"
        else
          render :text => "Invalid procedure name"
        end
    end

    def close_session
        @psession = PlanningSession.find(params[:id])
        @psession.close
        redirect_to action: "index"
    end

    def update
        ps = PlanningSession.where(:user => @user, :closed => 0).take
        ps.generate_plan()
        redirect_to action: "index"
    end

    def begin_task
        cur_task = current_planning_task()
        if(cur_task != nil)
            render :text => "Unable to start new task before finishing current" 
            return
        else
            pses = current_planning_session()

            #Find step in plan
            step_el = (pses.plan.select { |step| step["number"] == params[:plan_step].to_i})[0]

            #Create planning task
            new_task = PlanningTask.create(:planning_session => pses, :action => step_el["action"], :executor => step_el["executor"], :description => step_el["description"], :params => step_el["params"], :closed => 0)

            #Remove from plan
            pses.plan.delete(step_el)

            pses.save()
            
            PlannerEvent.create(:user => @user, :type_id => 3, :description => step_el.to_s)

            redirect_to :action => "index"
        end
    end

    def resume_task

        render :text => "Starting planning task"
    end

    def close_task
        task = PlanningTask.where(:planning_session => current_planning_session(), :id => params[:task]).take

        puts "xxxxx"
        puts "Commiting executor=#{task.executor}, action=#{task.action}"

        #It must do the PIK-component!
        case task.executor
        when "onthology"
            if(task.action == "develop")
                task.result = {:add => ["(finished onthology-development-step)"]}
            end
        when "psycho"
            if(task.action == "config")
                task.result = {:add => ["(finished psycho-config-step)"]}
            end
        when "configurator"
            if(task.action == "config_skills")
                task.result = {:add => ["(finished skills-extraction-select-step)"]}
            elsif(task.action == "config_training_impacts")
                task.result = {:add => ["(finished training-impact-development-step)"]}
            end
        when "tester"
            if(task.action == "develop")
                task.result = {:add => ["(finished testing-development-step)"]}
            elsif(task.action == "run")
                ont_id = task.params["onthology"]
                task.result = {:delete => {"pending-knowledge" => ont_id}}
                if(Random.rand(10) > 7)
                    task.result[:add] = {"low-knowledge" => ont_id}
                end
            end
        when "framer"
            if(task.action == "run")
                task.result = {:delete => {"pending-skills" => "frame-skill"}}
            end
        when "semnetter"
            if(task.action == "run")
                task.result = {:delete => {"pending-skills" => "sem-network-skill"}}
            end
        when "lingvo"
            if(task.action == "run")
                task.result = {:delete => {"pending-skills" => "linguistic-skill"}}
            end
        when "reasoner"
            if(task.action == "run")
                task.result = {:delete => {"pending-skills" => "reasoning-skill"}}
            end
        when "strateger"
            ont_id = task.params["onthology"]
            if(task.action == "generate")
                task.result = {:delete => {"low-knowledge" => ont_id}, :add => {"pending-tutoring" => ont_id}}
            elsif(task.action == "run")
                task.result = {:delete => {"pending-tutoring" => ont_id}, :add => {"pending-knowledge" => ont_id}}
            end
        else
            task.result = {}
            #render :text => "Unkown executor/command!"
        end

        #, :action => "develop"

        current_planning_session().commit_task(task)
        redirect_to :action => "index"
    end

    def test_run

        render :text => plan.join("<br/>")
    end
end
