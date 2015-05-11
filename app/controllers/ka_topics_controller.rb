class KaTopicsController < ApplicationController
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
    @constructs = Construct.all
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

  #TEMP: Пара временных методов, чтобы сделать отчет для ГВ
  def show_table_with_questions
    @topics = get_tree(params[:root_id], [])
    @questions = get_questions(@topics)
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

  def get_questions(node_arr)
    question_arr = []
    node_arr.each do |t|
      question_arr += t.ka_question
    end
    return question_arr
  end
end
