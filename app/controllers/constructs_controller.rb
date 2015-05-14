class ConstructsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
  end

  def create
    Construct.create(name: params[:name])
    redirect_to :back
  end

  def edit
    @construct = Construct.find(params[:id])
  end

  def update
    construct = Construct.find(params[:id])
    construct.update(name: params[:name])
    redirect_to constructs_path
  end

  def destroy
    Construct.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    if TopicConstruct.where(ka_topic_id: params[:topic_id], construct_id: params[:construct_id]).empty? && !params[:construct_id].nil?
      TopicConstruct.create(ka_topic_id: params[:topic_id], construct_id: params[:construct_id], mark: params[:mark])
    end

    redirect_to :back
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicConstruct.delete_all(ka_topic_id: params[:t_id], construct_id: params[:c_id])
    redirect_to :back
  end

  def calculate_relations
    topics = get_tree(params[:root_id], [])
    constructs = KaTopic.find(params[:root_id]).constructs

    0.upto(topics.count-1) do |i|
      (i+1).upto(topics.count) do |j|
        rel = calc_rel(topics[i], topics[j], constructs)
      end
    end

    rel.save
  end

  def calc_rel(top_a, top_b, constructs)
    sum = 0
    constructs.each do |c|
     sum += Numeric.abs(top_a.topic_constructs.where(construct_id: c.id).take - top_b.topic_constructs.where(construct_id: c.id).take) ^ 2
    end

    sum = Math.sqrt(sum / constructs.count) / 100

    rel = TopicRelation.new(ka_topic_id: top_a.id, related_topic_id: top_b.id)
    rel.type = sum
    #if sum < 0.3
      #rel[:type] = 0
    #elsif sum < 0.7
      #rel[:type] = 1
    #else
      #rel[:type] = 2
    #end

    return rel
  end

  def get_tree(id, node_arr)
    #children = KaTopic.where(parent_id: parent_id)
    #node_arr = node_arr + children
    cur_node = KaTopic.find(id)
    node_arr.push(cur_node)
    cur_node.children.each do |t|
      get_tree(t.id, node_arr)
    end
    return node_arr
  end
end
