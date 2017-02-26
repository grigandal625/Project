#coding: utf-8
class PlanningController < ApplicationController
    include PlanningHelper

    module ModeType
        DesignTime = 1
        RunTime = 2
    end

    def _index
        #@psession = current_planning_session()
        #@cur_task = @psession ? @psession.current_task() : nil

        #if(@user.role == 'admin')
        #@events = PlannerEvent.last(20)
        #puts "HERE GOES THE EVENTS: #{@events.size}"
        #redirect_to action: "_index"
        #end
    end
    
    def new_session
      @psession = current_planning_session()
      if (@psession != nil)
        render text: "Session already started"
      else
        schedule = Schedule.take
        case params[:procedure]
        when "tutor_designtime_initial"
          if(@user.role != 'admin')
            throw "Invalid user role"
          end

          state = ExtensionDatabase.generate_state(Schedule.current_week, ModeType::DesignTime, schedule)
          #{"finished" => []}
          ps = PlanningSession.create(:user => @user, :state => state, :closed => 0, :procedure => "tutor_designtime_initial")
          ps.generate_plan()
          #render action: "_index"
          #redirect_to action: "_index"
          _index
        when "tutor_runtime"

          if(@user.role == 'admin')
            throw "Invalid user role"
          end

          state = ExtensionDatabase.generate_state(Schedule.current_week, ModeType::RunTime, schedule)
          #{"pending-skills" => ["frame-skill", "sem-network-skill", "linguistic-skill", "reasoning-skill"], "pending-knowledge" => [23, 41], "pending-psycho" => ["main"], "low-knowledge" => [], "pending-tutoring" => []}
          ps = PlanningSession.create(:user => @user, :state => state, :closed => 0, :procedure => "tutor_runtime")
          ps.generate_plan()
          redirect_to action: "_index"

        else
          render :text => "Invalid procedure name"
        end
      end
    end

    def close_session
        @psession = PlanningSession.find(params[:id])
        @psession.close
        #redirect_to action: "_index"
        _index
        @psession = nil
    end

    def update
        ps = PlanningSession.where(:user => @user, :closed => 0).take
        ps.generate_plan()
        #redirect_to action: "_index"
        # _index
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

            #Find state atom
            state_atom = pses.state.atoms.find_by(task_name: step_el["task_name"])
            if (state_atom == nil)
              render :text => "Unable to find state atom"
            end

            #Create planning task
            new_task = PlanningTask.create(:planning_session => pses,
                                           :action => step_el["action"],
                                           :executor => step_el["controller"],
                                           :description => step_el["description"],
                                           :params => step_el["params"],
                                           :state_atom => state_atom,
                                           :closed => 0)
            p new_task.inspect

            #Remove from plan
            pses.plan.delete(step_el)

            pses.save()

            PlannerEvent.create(:user => @user, :type_id => 3, :description => step_el.to_s)

            #redirect_to :action => "index"
            update

            pik_wrapper = {"framer" => "framestudent", "onthology" => "ka_topics", "semnetter" => "semanticanswers",
              "lingvo" => "test"}
            redirect_to :controller => new_task["executor"], :action => "execute", :planning_task_id => new_task.id

            #pik_wrapper = {"framer" => "dummy", "onthology" => "dummy"}
            #redirect_to :controller => pik_wrapper[new_task["executor"]], :action => "execute", :planning_task_id => new_task.id

            #_index
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
                task.result = {:add => {"finished" => "onthology-development-step", :add => {"onthologies" => [55,11,123]}}}
            end
        when "psycho"
            if(task.action == "config")
                task.result = {:add => {"finished" => "psycho-config-step"}}
            elsif(task.action == "run")
                task.result = {:delete => {"pending-psycho" => "main"}}
            end
        when "configurator"
            if(task.action == "config_skills")
                task.result = {:add => {"finished" => "skills-extraction-select-step"}}
            elsif(task.action == "config_training_impacts")
                task.result = {:add => {"finished" => "training-impact-development-step"}}
            end
        when "tester"
            if(task.action == "develop")
                task.result = {:add => {"finished" => "testing-development-step"}}
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
        #redirect_to :action => "_index"
        _index
    end

    def test_run

        render :text => plan.join("<br/>")
    end
end
