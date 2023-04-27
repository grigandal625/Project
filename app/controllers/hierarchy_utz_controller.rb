class HierarchyUtzController < ApplicationController
  layout false

  def new
  end

  def create
    puts(params)
    u = HierarchyUtz.create(text: params[:name], description: params[:description], data: params[:data], ka_topics_id: params[:ka_topic_id], weight: params[:weight])
    u.save!
    redirect_to hierarchy_utz_path(u.id)
  end

  def show
    @u = HierarchyUtz.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @u.as_json }
    end
  end

  def destroy
    u = HierarchyUtz.find(params[:id])
    u.destroy
    redirect_to utz_path
  end

end
