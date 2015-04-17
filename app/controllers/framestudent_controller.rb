#coding: utf-8
class FramestudentController < ApplicationController
  layout 'test'
  def index

  end

  def show
    @studentframe = Studentframe.find(params[:id])
    @framestudentcode = Frame.new
    @framestudentcode.inic(@studentframe.studentcode)
    @framestudentcode.createframe(@studentframe.studentcode)
  end

  def createstudentframe
    @studentframe = Studentframe.new
    @studentframe.result = 0
    @studentframe.student = @user.student
    @studentframe.etalonframe = Etalonframe.offset(rand(Etalonframe.count)).first
    @studentframe.mistakes = ""
    @studentframe.isfinish = false
    @studentframe.studentcode = @studentframe.etalonframe.studentcode
    @studentframe.save
    redirect_to framestudent_path(@studentframe.id)
  end




  def updateframe
    if (params[:studentcode].size < 2500) #Ограничение для невозможноси передачи флуда


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
        solver = FrameSolver.new
        solver.inic(framestudentcode,ecode )
        solver.differentnames
        frame.studentmistakes = solver.mistakes.to_s
        frame.result =  100 + solver.result


        frame.isfinish = true

      end
    if frame.result < 0
      frame.result = 0
    end
      frame.save
    end
    redirect_to :back
  end
end
