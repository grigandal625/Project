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
    @tasks = []
    Task.find_each do |task|
      @tasks << {"id" => task.id,
                "sentence1" => task.sentence1[0..100] + '...',
                "reference" => 
                    "<a href=\"#{tasks_edit_path(task.id)}\">Редактировать</a>"}
    end
  end

  def new
  end

  def create
    sentences = []
    params[:sentences].split("\r\n").each{|sen| sentences << sen unless sen == ""}
    render text: sentences.inspect
    #Task.create(sentence1: sentences[0], sentence2: sentences[1], sentence3: sentences[2])
  end

  def edit
    @task = Task.find_by_id(params[:id])
  end

  def get_task
    if session[:variant] == nil
      @task = Task.first(:offset => rand(Task.count))
      session[:task_id] = @task.id
      session[:result_id] = Result.create
    else
      @task = Task.find(session[:task_id])
    end
    render 'tasks/get_v'
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
      render 'tasks/get_g'
    when 'G'
      gresult = result.create_g_result
      gresult.answer = params[:g_answer]
      gresult.mark = @task.g_answer.check_answer(gresult.answer)
      gresult.save
      render 'tasks/get_s'
    when 'S'
    end
    result.save
  end

end
