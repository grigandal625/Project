#coding: utf-8
class SemantictestsController < AdminToolsController
  def index
    #@etalon = Etalon.all
    #print (session[:user_id])
    
    user = User.find(session[:user_id])
    #print (user.student.fio)
    
    @etalons = []
    Etalon.find_each do |etalon|
      @etalons << {"id" => etalon.id,
                 "name" => etalon.name,
                 "reference" => 
      "<a target='_blank' href=\"#{semantictest_path(etalon.id, showmenu: false)}\">Редактировать</a>"}
    end
  end
  
  def new
  end
  
  
  
  def create 
    @etalon = Etalon.new()
    @etalon.name = params[:name]
    @etalon.save()
    redirect_to semantictests_path, notice: "Создано"
  end
  
  def show 
    @etalon = Etalon.find(params[:id])
  end
  
  def updateJson 
  	@etalon = Etalon.find(params[:id])
  	@etalon.etalonjson = params[:etalonjson]
  	@etalon.name = params[:name]
  	@etalon.nodejson = params[:namesjson]
  	@etalon.save()
  	render text: "Сохранено"
  end
  
  
end
