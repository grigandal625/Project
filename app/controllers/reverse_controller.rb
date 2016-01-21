#coding: utf-8
class ReverseController < ApplicationController
    include PlanningHelper
    skip_before_filter :verify_authenticity_token

  def index
    # @task = PlanningTask.find(params["planning_task_id"])
  end

  # def getfile
  #   # out = params[:id]+' '+params[:JSON]
   
  #   time = Time.now.utc.to_i 
  #   Dir.mkdir('public/uploads/JSON/reverse/'+params[:id]) unless File.exists?('public/uploads/JSON/reverse/'+params[:id])
  #   f = File.open('public/uploads/JSON/reverse/'+params[:id]+'/'+time.to_s+'.json', 'w+')
  #   f.puts(params[:trace])
  #   f.close()
  #   if params[:end]=='no' 
  #  @results = Result.new()
  #  @results.action = 'reverse'
  #  @results.user = User.find(params[:id])
  #  @results.startfile = time.to_s+'.json'
  #  @results.timebegin = time
  #  @results.save()
  #  render :text => "Конфигурация сохранена"
  #   else
  # @results = Result.where('user_id='+params[:id]).order('id DESC').only(:order, :where).limit(1).take!
  
  #  @results.timeend = time
  #  @results.endfile = time.to_s+'.json'
  #  @results.result = params[:e]
  #  @results.save()
  #   include PlanningHelper
  #   task = PlanningTask.find(params["planning_task_id"])
  #   task.result = {:delete => {"pending-skills" => "reasoning-skill"}}
  #   current_planning_session().commit_task(task)

  #   redirect_to "/"
        
  #  render :text => "Тестирование закончено. Ваша оценка: "+params[:e]
  #  end
   
  # end

  def saveResult
    @user = User.find (session["user_id"])
    date = Time.now.to_formatted_s(:short)
    result = Fbresult.new
    result.fio = @user.student.fio
    result.fb = "Обратный"
    result.result = params[:result]
    result.group = @user.student.group.number
    result.save
  end

end
