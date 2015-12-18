#coding: utf-8
class FramesController < ApplicationController
  def index
    @frames = Framedb.all
  end

  def translate
    stf = Studentframe.find(1)
    stf.student = @user.student
    stf.save

    frame = Frame.new
    frame.inic(params[:message])
    frame.saveframe(frame.createframe(params[:message]))

    redirect_to :back, :frame => 1
  end
end
