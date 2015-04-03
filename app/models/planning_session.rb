class PlanningSession < ActiveRecord::Base
    belongs_to :user
    has_many :planning_tasks

    serialize :state, JSON
    serialize :goal, JSON

    serialize :plan, JSON

    def close
        self.closed = 1
        self.save
    end

    def generate_plan
        problem_str = File.read(Rails.configuration.planning_kb + '/problem.pddl')

        #Form initial state
        initial_facts = self.state
        #initial_facts.push("(finished onthology-development-step)")

        problem_str = problem_str.gsub("##INITIAL-STATE##", initial_facts.join('\n'))

        cur_plan = []

        dir = Dir.mktmpdir
        begin
            #puts dir

            FileUtils.cp(Rails.configuration.planning_kb + '/domain.pddl', "#{dir}/domain.pddl")

            File.open("#{dir}/problem.pddl", 'w') { |file| file.write(problem_str) }

            Dir.chdir(dir) do
                #Run preprocess
                system("python #{Rails.configuration.planning_bin}/fast-downward.py domain.pddl problem.pddl --search 'lazy_greedy(ff(), preferred=ff())'")

                File.open("#{dir}/sas_plan", "r") do |f|
                f.each_line do |line|
                    if(!line.start_with?(";") && !line.start_with?("(int-"))
                        cur_plan.push(line)
                    end
                end
            end
            end
        ensure
          FileUtils.remove_entry_secure dir
        end

        cur_step_number = 0
        self.plan = []
        cur_plan.each do |pt|
            cur_step = interpret_pddl_action(pt)
            cur_step[:number] = cur_step_number
            cur_step_number = cur_step_number + 1
            self.plan.push(cur_step)
        end

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

        task.result["add"].each do |add_atom|
            self.state.push(add_atom)
        end

        self.generate_plan()

        if(self.plan.empty?)
            self.close()
        end
    end

    private
    def interpret_pddl_action(pddl_action)
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
            return cur_step
        when "execute-development-step-future"
            cur_step = step_mapping[parts[1]].clone
            cur_step[:available] = false
            return cur_step
        else
          return "Unkown action"
        end
    end
end
