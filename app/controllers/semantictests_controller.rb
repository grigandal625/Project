#coding: utf-8
class SemantictestsController < AdminToolsController
skip_before_filter :verify_authenticity_token
  def index
    @etalons = Etalon.all
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
  
  def results 
  	@semantic = Semanticnetwork.all
  end
  
end
