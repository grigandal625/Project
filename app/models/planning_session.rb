class PlanningSession < ActiveRecord::Base
    belongs_to :user
    has_many :planning_tasks
    has_one :state, class_name: "PlanningState"

    serialize :goal, JSON

    serialize :plan, JSON
    def close
        self.closed = 1
        self.save

        PlannerEvent.create(:user => self.user, :type_id => 2, :description => "executed  tasks") ##{planning_tasks.size}
    end

    def generate_plan
        start_time = Time.now.to_f

        kb_mapping = {"tutor_designtime_initial" => ["dt_domain.pddl", "dt_problem.pddl"], "tutor_runtime" => ["rt_domain.pddl", "rt_problem.pddl"]} 

        problem_str = File.read(Rails.configuration.planning_kb + '/' + kb_mapping[self.procedure][1])

        #Form initial state
        init_state = generate_initial_state(self.procedure, self.state)
        #init_state = ["", ""] #TODO real state generation
        p init_state.inspect #TODO remove

        problem_str = problem_str.gsub("##OBJECTS##", init_state[0])
        problem_str = problem_str.gsub("##INITIAL-STATE##", init_state[1])
        p problem_str.inspect #TODO remove

        cur_plan = []

        dir = Dir.mktmpdir
        begin
          puts dir

          FileUtils.cp(Rails.configuration.planning_kb + '/' + kb_mapping[self.procedure][0], "#{dir}/domain.pddl")

          File.open("#{dir}/problem.pddl", 'w') { |file| file.write(problem_str) }

          Dir.chdir(dir) do
            #Run preprocess

            run_cmd = "python #{Rails.configuration.planning_bin}/fast-downward.py domain.pddl problem.pddl --search 'lazy_greedy(ff(), preferred=ff())'"
            puts "Running #{run_cmd}"
            system(run_cmd)

            File.open("#{dir}/sas_plan", "r") do |f|
              f.each_line do |line|
                if(!line.start_with?(";") && !line.start_with?("(int-"))
                  cur_plan.push(line)
                end
              end
            end
          end

        ensure
          #FileUtils.remove_entry_secure dir
        end

        p cur_plan.inspect

        cur_step_number = 0
        self.plan = []
        cur_plan.each do |pt|
            
            if(self.procedure == "tutor_designtime_initial")
                cur_step = interpret_pddl_action_dt(pt)
            else
                cur_step = interpret_pddl_action_rt(pt)
            end

            cur_step[:number] = cur_step_number
            cur_step_number = cur_step_number + 1
            self.plan.push(cur_step)
        end

        p plan.inspect

        end_time = Time.now.to_f
        
        PlannerEvent.create(:user => self.user, :type_id => 0, :description => "generated in #{(end_time-start_time).to_s} sec")
        self.save
    end

    def current_task
        return PlanningTask.where(:planning_session => self, :closed => 0).take
    end

    def completed_tasks
        return PlanningTask.where(:planning_session => self, :closed => 1).order(created_at: :asc)
    end

    def commit_task(task)
        task.closed = 1
        task.save

        if(task.result["delete"])
            task.result["delete"].each{|key, value|
                if(self.state[key])
                    self.state[key].delete(value)
                end
            }
        end

        if(task.result["add"])
            task.result["add"].each{|key, value|
                if(!self.state[key])
                    self.state[key] = []
                end
                self.state[key].push(value)
            }
        end

        self.save
        self.generate_plan()

        if(self.plan.empty?)
            self.close()
        end

        PlannerEvent.create(:user => self.user, :type_id => 4, :description => "result=#{task.result.to_s}")
    end

    private

    def generate_initial_state(proc_name, state)
        case proc_name
        when "tutor_designtime_initial"

            facts = []

            state["finished"].each do |f|
                facts.push("(finished #{f})")
            end

            return ["", facts.join('\n')]
        when "tutor_runtime"

            kbs = []
            init_facts = []
            psyhos = []

            state.knowledge.each do |atom|
              kb_name = "kb-#{atom.task_name}"
              kbs.push(kb_name)
              init_facts.push("(pending #{kb_name})")
            end

            skills = []
            state.skill.each do |atom|
              init_facts.push("(pending #{atom.task_name})")
              skills.push(atom.task_name)
            end

            #state["pending-tutoring"].each do |pt|
            #    kb_name = "kb-#{pt}"
            #    init_facts.push("(pending-tutoring #{kb_name})")
            #    kbs.push(kb_name)
            #end            

            #state["low-knowledge"].each do |lk|
            #    kb_name = "kb-#{lk}"
            #    init_facts.push("(low-knowledge-level #{kb_name})")
            #    kbs.push(kb_name)
            #end

            #if(!state["pending-psycho"].empty?)
            #    psyhos.push("psycho-main")
            #    init_facts.push("(pending psycho-main)")
            #end

            kbs = kbs.uniq
            return [kbs.join(' ') + " - knowldege\n" + skills.join(' ') + " - skill\n" + psyhos.join(' ') + " - psycho\n", init_facts.join(' ')]
        else
            return ["", ""]
        end
    end

    def interpret_pddl_action_dt(pddl_action)
        plain_action = pddl_action[1, pddl_action.length - 3]
        parts = plain_action.split(" ")

        step_mapping = {"onthology-development-step" => {:description => "Построение онтологии курса/дисциплины", :executor => "onthology", :action => "develop"}, 
                        "psycho-config-step" => {:description => "Конфигурация построения психологического портрета", :executor => "psycho", :action => "config"}, 
                        "skills-extraction-select-step" => {:description => "Выбор компонентов выявления уровня умений", :executor => "configurator", :action => "config_skills"},
                        "testing-development-step" => {:description => "Разработка тестовых заданий", :executor => "tester", :action => "develop"},
                        "training-impact-development-step" => {:description => "Разработка обучающих воздействий", :executor => "configurator", :action => "config_training_impacts"}
            }

        case parts[0]
        when "execute-development-step"
            cur_step = step_mapping[parts[1]].clone
            cur_step[:available] = true
        when "execute-development-step-future"
            cur_step = step_mapping[parts[1]].clone
            cur_step[:available] = false
        else
            cur_step = {:description => "Unkown action"}
            cur_step[:available] = false
        end

        return cur_step
    end

    def interpret_pddl_action_rt(pddl_action)
        plain_action = pddl_action[1, pddl_action.length - 3]
        parts = plain_action.split(" ")

        pddl_act = parts[0]
        avail = !pddl_act.start_with?("future-")
        pddl_act = pddl_act.gsub("future-", "")

        cur_step = {}
        ext = ExtensionDatabase.get_extension_for_task(pddl_act, parts[1])
        if(ext == nil)
            cur_step[:available] = false
            cur_step[:description] = "Неизвестная задача"
        else
            cur_step[:available] = true
            cur_step[:description] = ext.get_task_description(parts[1])

            ep = ext.get_task_exec_path(pddl_act, parts[1])
            cur_step[:controller] = ep["controller"]
            cur_step[:action] = ep["action"]
            cur_step[:params] = ep["params"]
        end

        return cur_step

        skill_mappings = {"frame-skill" => {:description => "Выявить уровень умений моделировать ситуации с помощью фреймов", :executor => "framer", :action => "run"}, 
                            "sem-network-skill" => {:description => "Выявить уровень умений моделировать ситуации с помощью семантических сетей", :executor => "semnetter", :action => "run"},
                            "linguistic-skill" => {:description => "Выявить уровень умений строить компоненты лингвистической модели подъязыка деловой прозы", :executor => "lingvo", :action => "run"},
                            "reasoning-skill" => {:description => "Выявить уровень умений моделировать прямой/обратный вывод", :executor => "reasoner", :action => "run"}
            }

        case pddl_act
        when "extract-skill"
            cur_step = skill_mappings[parts[1]].clone
        when "extract-knowledge"
            ont_id = parts[1].gsub("kb-", "").to_i
            cur_step = {:description => "Выявить уровень знаний (в соответствии с фрагментом онтологии по курсу #{ont_id})", :executor => "tester", :action => "run", :params => {:onthology => ont_id}}
        when "extract-psycho"
            cur_step = {:description => "Построить психологический портрет", :executor => "psycho", :action => "run"}
        when "generate-tutor-strategy"
            ont_id = parts[1].gsub("kb-", "").to_i
            cur_step = {:description => "Сформировать стратегию обучения (#{ont_id})", :executor => "strateger", :action => "generate", :params => {:onthology => ont_id}}
        when "release-tutor-strategy"
            ont_id = parts[1].gsub("kb-", "").to_i
            cur_step = {:description => "Пройти обучение (#{ont_id})", :executor => "strateger", :action => "run", :params => {:onthology => ont_id}}
        else
            cur_step = {:description => "Unkown action"}
            cur_step[:available] = false
        end

        cur_step[:available] = avail

        return cur_step
    end
end
