#coding: utf-8
class TasksController < ApplicationController
  layout 'task'
  helper :all
  before_action :check_admin

  def index
    @tasks = []
    Task.find_each do |task|
      @tasks << {"id" => task.id,
                 "sentence1" => task.sentence1[0..100] + '...',
                 "reference" => 
      "<a href=\"#{edit_task_path(task.id)}\">Редактировать</a>"}
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

  private
  def check_admin
    if @user.role != 'admin'
      render status: :forbidden, text: "You aren't allowed to see this page"
    end
  end

end
