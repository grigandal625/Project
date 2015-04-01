class PlanningController < ApplicationController
    def test_run

        problem_str = File.read(Rails.configuration.planning_kb + '/problem.pddl')


        #Form initial state
        initial_facts = []
        initial_facts.push("(finished onthology-development-step)")

        problem_str = problem_str.gsub("##INITIAL-STATE##", initial_facts.join('\n'))

        plan = []

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
                    if(!line.start_with?(";"))
                        plan.push(line)
                    end
                end
            end
            end
        ensure
          FileUtils.remove_entry_secure dir
        end

        render :text => plan.join("<br/>")
    end
end
