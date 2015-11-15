class WorksController < ApplicationController 
  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
 
    if @work.save
     puts 'saved'
    else
      render 'new'
    end
  end

  private
    def work_params
      params.require(:work).permit(:tip, :name, :description)
    end 
end
