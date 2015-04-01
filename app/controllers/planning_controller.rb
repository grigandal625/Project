class PlanningController < ApplicationController
    def test_run

        plan = []

        dir = Dir.mktmpdir
        begin
            FileUtils.cp(Rails.configuration.planning_kb + '/domain.pddl', "#{dir}/domain.pddl")
            FileUtils.cp(Rails.configuration.planning_kb + '/problem.pddl', "#{dir}/problem.pddl")

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

        #system(Rails.configuration.planning_bin)
        render :text => plan.join(",")
    end
end
