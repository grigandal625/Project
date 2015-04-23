#coding: utf-8
class FrameadminController < AdminToolsController
  def index
    @etalons = Etalonframe.all
  end

  def show

    @etalon = Etalonframe.find(params[:id])

    @framecode = Frame.new
    @framecode.inic(@etalon.framecode)
    @framecode.createframe(@etalon.framecode)
  end

  def createframe
    etalon = Etalonframe.new
    etalon.name = params[:name]
    etalon.framecode = "{}"
    etalon.dictionary = "{}"
    etalon.studentcode = "{}"
    etalon.kbmistakes = "50,20,10,5,10,5,10"
    etalon.save
    redirect_to :back
  end

  def destroy
    Etalonframe.find(params[:id]).destroy
    redirect_to :back
  end

  def new

  end


  def mistakes

  end


  def results
    @results = Studentframe.all
  end




  def updateframe

    etalon = Etalonframe.find(params[:id])
    etalon.framecode = params[:framecode]
    etalon.dictionary = params[:dictionary]
    etalon.studentcode = params[:studentcode]
    framestudentcode = Frame.new
    framestudentcode.inic(params[:framecode])
    framestudentcode.createframe(params[:framecode])

    etalon.kbmistakes = params[:parametalonname0] + "," + params[:parametalonname1] + "," + params[:parametalonname2] +  "," + params[:parametalonname3] + "," + params[:parametalonname4] + "," + params[:parametalonname5]  + "," + params[:parametalonname6]




    framecode = Frame.new
    framecode.inic(params[:framecode])
    framecode.createframe(params[:framecode])
    etalon.dictionary = framecode.getdictionary.to_s
    etalon.mistakes = "Ошибки в фрейме" + framecode.mistakes.to_s + "  \nОшибки в фрейме для студента " + framestudentcode.mistakes.to_s
    etalon.save

    redirect_to :back
  end
end
