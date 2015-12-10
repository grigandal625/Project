class SchedulesController < ApplicationController
	def index
          @schedules = Schedule.all
        end
        
	def show #удаление
          Schedule.find(params[:id]).destroy
        
          redirect_to schedules_path
        end

        def new
          @schedule = Schedule.new
	end

        def edit
          @schedule = Schedule.find(params[:id])
        end

	def create
	  @schedule = Schedule.new(schedule_params)
 
          if @schedule.save
             redirect_to schedules_path
          else
             render 'new'
          end
	end
	
        def update
          @schedule = Schedule.find(params[:id])
 
          if @schedule.update(schedule_params)
             redirect_to schedules_path
          else
              render 'edit'
          end
        end
 
	def pokaz
           @schedule = Schedule.find(params[:id])
        end
  
        private
          def schedule_params
            params.require(:schedule).permit(:group, :psyho, :knowledge1, :knowledge2, :frame_sem, :vivod )
        end

end
