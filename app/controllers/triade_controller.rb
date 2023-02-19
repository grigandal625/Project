class TriadeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def start
    topic = KaTopic.find(params[:id])
    root = topic.get_root()
    triades = Triade.where(root_topic: root)
    if triades.count
      redirect_to triade_show_path(triades[0].id)
    else
      redirect_to triade_list_path(root.id)
    end
  end

  def formate
    @roots = KaTopic.where(parent_id: nil)
  end

  def list
    topic = KaTopic.find(params[:id])
    @root = topic.get_root()
    if request.request_method() == 'POST' || Triade.where(root_topic: @root).count == 0
      Triade.where(root_topic: @root).destroy_all()
      groups = @root.get_groups_from_root()
      triade_list = KaTopic.formate_triades(groups)
      triade_list.each do |t|
        triade = Triade.new(first_topic: t[0], second_topic: t[1], third_topic: t[2], constructs: nil, root_topic: @root, accepted: false)
        triade.save
      end
    end
    @triades = Triade.where(root_topic: @root)
  end

  def show
    @triade = Triade.find(params[:id])
    @triade_list = Triade.where(root_topic: @triade.root_topic)
    @construct_name = ''
    if !@triade.constructs_id.nil?
      @construct_name = Construct.find(@triade.constructs_id).name
    end
    render :layout => "layout_for_show_only"
  end

  def show_grid
    @root = KaTopic.find(params[:id])
    @all_topics = @root.get_tree
    @constructs = Construct.all
    render :layout => "layout_for_show_only"
  end

  def update_grid
    topic_construct = TopicConstruct.where(ka_topic_id: params[:ka_topic_id], construct_id: params[:construct_id])[0]
    mark = params[:mark]

    if mark == '' || mark.nil? || (!mark && mark != 0)
      mark = nil
    else
      mark = mark.to_i
    end

    if mark.nil? && !topic_construct.nil?
      TopicConstruct.delete_all(:ka_topic_id => params[:ka_topic_id], :construct_id => params[:construct_id])
    else
      if topic_construct.nil?
        topic_construct = TopicConstruct.new(ka_topic_id: params[:ka_topic_id], construct_id: params[:construct_id], mark: mark)
      else
        topic_construct.mark = mark
      end
      if !mark.nil?
        topic_construct.save
      end
    end
    redirect_to :back
    
  end

  def constructs_triade
    triade = Triade.find(params[:id])
    cs = Construct.where(name: params[:name])
    if cs.count
      triade.constructs_id = cs[0].id
    else
      c = Construct.new(name: params[:name])
      c.save
      triade.constructs_id = c.id
    end
    triade.accepted = true
    triade.selected_theme = params[:selected_theme].to_i
    triade.save
    redirect_to :back
  end

  def lock_triade
    triade = Triade.find(params[:id])
    triade.constructs_id = nil
    triade.selected_theme = nil
    triade.accepted = true
    triade.save
    redirect_to :back
  end
  
end
