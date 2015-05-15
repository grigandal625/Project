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

    #Перечень вопросов, которые ГВ выделила для тестирования
    @questions_ids = [452, 3, 448, 5, 7, 8, 6, 12, 234, 13, 21, 22, 23, 15, 16, 453, 20, 14, 454, 455, 456, 41, 42, 43, 35, 36, 38, 39,
                      457, 458, 459, 460, 40, 440, 441, 442, 44, 446, 461, 462, 463, 464, 50, 51, 447, 443, 444, 53, 54, 445, 65, 66, 67,
                      62, 63, 64, 55, 56, 57, 58, 59, 60, 61, 247, 68, 243, 214, 215, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257,
                      258, 259, 260, 71, 73, 72, 70, 69, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228]
    @questions = KaQuestion.find(@questions_ids)
    #@questions = get_questions(@topics)
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
