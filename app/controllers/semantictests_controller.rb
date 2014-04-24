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
	 if params[:date] == nil
      @date_from = 1.year.ago
      @date_to = Date.today
    else
      @date_from = params[:date][:from].to_date || 1.year.ago
      @date_to = params[:date][:to].to_date || Date.today
    end
    @groups = Group.all
    groups_ids = params[:group] || ""
    groups_ids = (groups_ids == "" ? @groups.ids : groups_ids)
    
    @results = []

    @semantic = Semanticnetwork.all    
   
  end
  
end
