#coding: utf-8
class FramestudentController <  ApplicationController
skip_before_filter :verify_authenticity_token
include PlanningHelper

  def index

  end

	def execute
		session["planning_task_id"] = params[:planning_task_id]
		createstudentframe

	end

  def show
    @studentframe = Studentframe.find(params[:id])
    @framestudentcode = Frame.new
    @framestudentcode.inic(@studentframe.studentcode)
    @framestudentcode.createframe(@studentframe.studentcode)
    @mytime = Time.now
  end

  def createstudentframe

		setOfFrames = Etalonframe.where(isuse:  true)
		frsize = setOfFrames.size
		if frsize > 0
		  @studentframe = Studentframe.new
		  @studentframe.result = 0
		  @studentframe.student = @user.student
			randFr = setOfFrames[rand(frsize)]
		  @studentframe.etalonframe = randFr
		  @studentframe.mistakes = ""
		  @studentframe.isfinish = false

		  @studentframe.studentcode = @studentframe.etalonframe.studentcode
		  @studentframe.created_at= Time.now
		  @studentframe.save

		  redirect_to framestudent_path(@studentframe.id)
		else
			redirect_to :back
		end
  end

  def destroy
    Studentframe.find(params[:id]).destroy
    redirect_to :back
  end


  def updateframe
    if (params[:studentcode].size < 4000) #Ограничение для невозможноси передачи флуда
      frame = Studentframe.find(params[:id])
      frame.studentcode = params[:studentcode]
      framestudentcode = Frame.new
      framestudentcode.inic(params[:studentcode])
      framestudentcode.createframe(params[:studentcode])

      ecode = Frame.new
      ecode.inic(frame.etalonframe.framecode)
      ecode.createframe(frame.etalonframe.framecode)
      frame.mistakes = "Ошибки в фрейме: "  + framestudentcode.mistakes.to_s

      if params[:commit]  == "Завершить"
        @solver = FrameSolver.new
        @solver.inic(framestudentcode, ecode)

        frame.studentmistakes = @solver.mistakes.to_s
        frame.result = @solver.result
        frame.isfinish = true

      end
		  if frame.result.to_i < 0
		    frame.result = "0"
		  end
      frame.save
    end
    redirect_to :back
  end
end
