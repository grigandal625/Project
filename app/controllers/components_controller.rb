class ComponentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
  end

  def create
    Component.create(name: params[:name])
    redirect_to :back
  end

  def edit
    @component = Component.find(params[:id])
  end

  def update
    component = Component.find(params[:id])
    component.update(name: params[:name])
    redirect_to components_path
  end

  def destroy

    if !TopicComponent.where(component_id: params[:id]).empty?
	@top = TopicComponent.where(component_id: params[:id])
	@top.find_each do |t|
	    t.destroy
	end
    end

    #TopicComponent.where("component_id = ?",params[:id]).destroy
    Component.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    if TopicComponent.where(ka_topic_id: params[:topic_id], component_id: params[:component_id]).empty? && !params[:component_id].nil?
      TopicComponent.create(ka_topic_id: params[:topic_id], component_id: params[:component_id])
    end

    redirect_to :back
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicComponent.delete_all(ka_topic_id: params[:t_id], component_id: params[:c_id])
    redirect_to :back
  end
end
