#coding: utf-8
class TasksController < AdminToolsController

  def index
    @tasks = []
    Task.find_each do |task|
      @tasks << {"id" => task.id,
                 "sentence1" => task.sentence1[0..100] + '...',
                 "reference" => 
      "<a target=\"_blanc\" href=\"#{edit_task_path(task.id,
                                     showmenu: false)}\">Редактировать</a>"}
    end
  end

  def new
  end

  def create
    sentences = []
    params[:sentences].split("\r\n").each{|sen| sentences << sen unless sen == ""}
    #render text: sentences.inspect
    task = Task.create(sentence1: sentences[0], sentence2: sentences[1],
                sentence3: sentences[2])
    task.create_v_answer
    task.v_answer.create_bnf(bnf_json: "{}")
    task.create_g_answer
    task.create_s_answer
    task.save
    redirect_to edit_task_path(task)
  end

  def edit
    @task = Task.find_by_id(params[:id])
    @gans = @task.g_answer.answer
    @showmenu = false
  end

  def update
    task = Task.find(params[:id])
    task.v_answer.set_rules(params[:bnf])
    task.g_answer.answer = params[:Ganswer]
    task.g_answer.answer = params[:Ganswer] unless params[:ignore_g]
    sentences = []
    params[:sentences].split("\r\n").each{|sen| sentences << sen unless sen == ""}
    task.update_attributes(sentence1: sentences[0], sentence2: sentences[1],
                sentence3: sentences[2])
    task.save
    redirect_to tasks_path
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path
  end

end
