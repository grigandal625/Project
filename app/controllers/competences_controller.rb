class CompetencesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
  end


  def create
    Competence.create(code: params[:code], description: params[:description])
    redirect_to :back
  end

  def edit
    @competence = Competence.find(params[:id])
  end

  def update
    competence = Competence.find(params[:id])
    competence.update(code: params[:code], description: params[:description])
    redirect_to competences_path
  end

  def destroy
    Competence.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    if TopicCompetence.where(ka_topic_id: params[:topic_id], competence_id: params[:competence_id]).empty?
      TopicCompetence.create(ka_topic_id: params[:topic_id], competence_id: params[:competence_id], weight: params[:weight])
    end

    redirect_to :back
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicCompetence.delete_all(ka_topic_id: params[:t_id], competence_id: params[:c_id])
    redirect_to :back
  end
end
