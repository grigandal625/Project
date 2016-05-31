class TimetableTemplatesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def new

  end
  def create
    @template  = TimetableTemplate.new(timetable_template_params)
    if @template.save
      respond_to do |format|
        format.js
      end
    end
  end
  def destroy
    @template = TimetableTemplate.find(params[:id])
    if @template.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def timetable_template_params
    params.require(:timetable_template).permit(:name, :json)
  end
end
