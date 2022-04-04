class ComponentElementsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"
  
  def index
    
  end

  def create
    component = Component.find(params[:component_id])
    ComponentElement.create(tag: params[:tag], name: params[:name], desc: params[:desc], components_id: params[:component_id], is_multiple: params[:is_multiple], size: params[:size])
    redirect_to component_edit_view_path(component)
  end

  def new
    print(params)
    $component = Component.find(params[:component_id])
  end
end
