#coding: utf-8
class TasksController < ApplicationController
  layout 'task'
  helper :all

#temp shit
  def get_s
    @task = Task.find(1)
  end
#temp shit

  def index
    if @user.role == 'admin'
      @tasks = []
      Task.find_each do |task|
        @tasks << {"id" => task.id,
                   "sentence1" => task.sentence1[0..100] + '...',
                   "reference" => 
        "<a href=\"#{tasks_edit_path(task.id)}\">Редактировать</a>"}
      end
    else
      render status: :forbidden, text: "You aren't allowed to see this page"
    end
  end

  def new
    if @user.role != 'admin'
      render status: :forbidden, text: "You aren't allowed to see this page"
    end
  end

  def create
    sentences = []
    params[:sentences].split("\r\n").each{|sen| sentences << sen unless sen == ""}
    render text: sentences.inspect
    #Task.create(sentence1: sentences[0], sentence2: sentences[1], sentence3: sentences[2])
  end

  def edit
    if @user.role == 'admin'
      @task = Task.find_by_id(params[:id])
    else
      render status: :forbidden, text: "You aren't allowed to see this page"
    end
  end

  def get_task
    if @user.role == 'student'
      if session[:task_id] == nil
        @task = Task.first(offset: rand(Task.count))
      else
        @task = Task.find(session[:task_id])
      end
      session[:task_id] = @task.id
      result = @task.results.create
      result.student = @user.student
      session[:result_id] = result.id
      render 'tasks/get_g'
    else
      render status: :forbidden, text: "You aren't a student"
    end
  end

  def next_component
    @task = Task.find(session[:task_id])
    result = Result.find(session[:result_id])
    case params[:component]
    when 'V'
      v_answer_bnf = JSON.parse(params[:v_answer_bnf])
      vresult = result.create_v_result
      vresult.create_bnf
      vresult.bnf.init_bnf(v_answer_bnf)
      vresult.mark = @task.v_answer.check_answer(vresult.bnf)
      vresult.save
      render 'tasks/get_s'
    when 'G'
      gresult = result.create_g_result
      gresult.answer = params[:g_answer]
      gresult.mark = @task.g_answer.check_answer(gresult.answer)
      gresult.save
      render 'tasks/get_v'
    when 'S'
    end
    result.save
  end

end
