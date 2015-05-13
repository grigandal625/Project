class KaTopicsController < ApplicationController
  include PlanningHelper

  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def show
  end

  def new
    topic = KaTopic.new
    topic.text = params[:text]
    if params[:parent_id]
      topic.parent_id = params[:parent_id]
    end
    topic.save
    redirect_to :back
  end

  def create
  end

  def index
  end

  def edit
    @topic = KaTopic.find(params[:id])
    @competences = Competence.all

    @task = PlanningTask.find(session[:planning_task_id])
  end

  def edit_text
    topic = KaTopic.find(params[:id])
    if topic and params[:text]
      topic.text = params[:text]
      topic.save
    end
    redirect_to :back
  end

  def destroy
    topic = KaTopic.find(params[:id])
    topic.destroy
    redirect_to :back
  end

  def execute
    session[:planning_task_id] = params[:planning_task_id]
    redirect_to action: "index"
  end

  def commit
    task = PlanningTask.find(session[:planning_task_id])
    root_nodes_ids = KaTopic.where(parent_id: nil).pluck(:id)
    task.result = {:add => {"finished" => "onthology-development-step", :add => {"onthologies" => root_nodes_ids}}}
    current_planning_session().commit_task(task)
    session[:planning_task_id] = nil

    redirect_to "/"
  end
end
