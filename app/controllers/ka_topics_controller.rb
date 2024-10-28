require "ancestry"

class KaTopicsController < ApplicationController
  include PlanningHelper

  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def self.create_extension
    ext = ExtensionDatabase::ATExtension.new
    ext.ext_type = ExtensionDatabase::ExtensionType::Other
    ext.description = "Компонент построения онтологии курса/дисциплины"
    ext.tasks = ["onthology-development-step"]

    ext.generate_state = lambda { |mode_id, week_id, schedule, state|
      atom = StateFacts.create(
        task_name: "onthology-development-step",
        state: 1,
      )
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Построение онтологии курса/дисциплины"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if ((pddl_act == "execute-development-step") && (leaf_id == "onthology-development-step"))
        return { "controller" => "ka_topics", "params" => {} }
      else
        return {}
      end
    }

    return ext
  end

  def full_tree
    @roots = KaTopic.where(parent_id: nil)
    render json: @roots.to_json
  end

  def formate_to_node(topic)
    return {
             id: topic.id.to_s,
             type: "topic",
             data: self.get_topic_node_data(topic),
           }
  end

  def collect_nodes_and_edges(topic)
    nodes = []
    edges = []
    nodes.push(self.formate_to_node(topic))
    # TopicRelation.where(ka_topic: topic).each do |rel|
    #   target_topic = rel.related_topic
    #   if target_topic.get_root.id == topic.get_root.id
    #     edge_id = ["rg", "rs", "rw"][rel.rel_type] + "-" + topic.id.to_s + "-" + target_topic.id.to_s
    #     edge_ids = edges.map do |e|
    #       e = e[:id]
    #     end
    #     if not edge_ids.include?(edge_id)
    #       edges.push({
    #         id: edge_id,
    #         source: topic.id.to_s,
    #         target: target_topic.id.to_s,
    #         type: ["aggregation", "association", "weak"][rel.rel_type],
    #       })
    #     end
    #   end
    # end

    utz_class_list = [TestUtzQuestion, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, LikertUtz, HierarchyUtz]

    utz_class_list.each do |utzClass|
      utz_list = []
      if utzClass.column_names.include?("ka_topics_id")
        utz_list = utzClass.where(ka_topics_id: topic.id)
      else
        utz_list = utzClass.where(ka_topic_id: topic.id)
      end
      utz_list.each do |utz|
        nodes.push({
          id: "ett" + utz.id.to_s,
          type: "ett",
          data: self.get_utz_node_data(utz, utzClass),
        })
        edges.push({
          id: "re" + topic.id.to_s + "-" + "ett" + utz.id.to_s,
          source: topic.id.to_s,
          target: "ett" + utz.id.to_s,
          type: "re",
        })
      end
    end

    topic.children.each do |child|
      edges.push({
        id: "rh" + topic.id.to_s + "-" + child.id.to_s,
        source: topic.id.to_s,
        target: child.id.to_s,
        type: "hierarchy",
      })
      res = self.collect_nodes_and_edges(child)
      nodes.concat(res[:nodes])
      edges.concat(res[:edges])
    end
    return { nodes: nodes, edges: edges }
  end

  def nodes_and_edges
    @root = KaTopic.find(params[:id])
    data = self.collect_nodes_and_edges(@root)
    render json: data
  end

  def get_utz_node_data(utz, utzClass)
    result = utz.attributes
    result[:ett_type] = utzClass.name.underscore
    if result[:ett_type] == "hierarchy_utz"
      result.delete("data")
      result.delete(:data)
    end

    return result
  end

  def get_topic_node_data(topic)
    data = {
      name: topic.text,
      id: topic.id,
      parent_id: topic.parent_id,
      questions: [],
    }

    KaQuestion.where(ka_topic: topic).each do |q|
      data[:questions].push({
        id: q.id,
        text: q.text,
        difficulty: q.difficulty,
      })
    end

    return data
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: KaTopic.find(params[:id]).get_tree }
    end
  end

  def children
    @topic = KaTopic.find(params[:id])
    render json: @topic.children
  end

  def questions
    @topic = KaTopic.find(params[:id])
    render json: @topic.ka_question
  end

  def competences
    @topic = KaTopic.find(params[:id])
    render json: @topic.topic_competences
  end

  def constructs
    @topic = KaTopic.find(params[:id])
    render json: @topic.topic_constructs
  end

  def set_competence_relation
    topic = KaTopic.find(params[:id])
    competence = Competence.find(params[:competence_id])
    weight = params[:weight].to_i

    if TopicCompetence.where(ka_topic: topic, competence: competence).empty?
      t = TopicCompetence.create(ka_topic: topic, competence: competence, weight: weight)
    else
      t = TopicCompetence.find_by(ka_topic: topic, competence: competence)
      t.weight = weight
      t.save
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: t.as_json }
    end
  end

  def delete_competence_relation
    ka_topic_id = params[:id].to_i
    competence_id = params[:competence_id].to_i
    all_relations = TopicCompetence.where(ka_topic_id: ka_topic_id, competence_id: competence_id)
    all_relations.delete_all
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { "success": true } }
    end
  end

  def components
    @topic = KaTopic.find(params[:id])
    render json: @topic.topic_components
  end

  def constructs
    @topic = KaTopic.find(params[:id])
    render json: @topic.topic_constructs
  end

  def etts
    @topic = KaTopic.find(params[:id])
    render json: @topic.test_utz_topic
  end

  def new
    topic = KaTopic.new
    topic.text = params[:text]
    if params[:parent_id]
      parent = KaTopic.find(params[:parent_id])
      topic.parent = parent
    end
    topic.save!
    redirect_to :back
  end

  def create
  end

  def index
  end

  def delete_utz_connection
    utz_data = params[:utz_data]
    test_utz_topic_id = utz_data.split(",")[0].to_i
    type = utz_data.split(",")[1].to_i

    case type
    when 1
      TestUtzTopic.find(test_utz_topic_id).delete()
      # when 2 для других типов утз доделать
    end

    redirect_to :back
  end

  def edit
    @topic = KaTopic.find(params[:id])

    @topic_utz_set = []

    TestUtzTopic.where(ka_topic: @topic).each do |topic_utz|
      @topic_utz_set.push({ type: 1, data: topic_utz })
    end

    # такие же циклы нужны для остальных типов утз

    @competences = Competence.all
    if (session[:planning_task_id] != nil)
      @task = PlanningTask.find(session[:planning_task_id])
    end
    @constructs = Construct.all
    @components = Component.all
    load_quizzes
  end

  def edit_text
    topic = KaTopic.find(params[:id])
    if topic and params[:text]
      topic.text = params[:text]
      topic.save
    end
    redirect_to :back
  end

  def edit_utz
    type = params[:utz_data].split(",")[0]
    ka_topic_id = params[:id]
    topic = KaTopic.find(ka_topic_id)
    utz_id = params[:utz_data].split(",")[1].to_i
    weight = params[:weight]
    ett_class = TestUtzTopic.ett_types_mapping[type.to_sym][:model]
    ett = ett_class.find(utz_id)
    ett_arg = { type.to_sym => ett }
    if TestUtzTopic.where(ka_topic: topic, **ett_arg).empty?
      TestUtzTopic.create(ka_topic: topic, weight: weight, **ett_arg)
    else
      c = TestUtzTopic.find_by(ka_topic: topic, **ett_arg)
      c.weight = weight
      c.save!
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
    transition = PlanningState::TransitionDescriptor.new
    transition.from = 1
    transition.to = 3
    task.state_atom.transit_to transition
    current_planning_session().commit_task(task)
    session[:planning_task_id] = nil

    redirect_to "/"
  end

  def show_all_relations
    topic = KaTopic.find(params[:id])
    root = topic
    @rt = root
    rel_type_mapping = ["Сильная", "Средняя", "Слабая"]

    @output = []
    @json_output = []

    TopicRelation.where(ka_topic_id: root.id).each do |r|
      @output.push({
        topic: r.ka_topic.text,
        related_topic: r.related_topic.text,
        relation_type: rel_type_mapping[r.rel_type],
      })
      @json_output.push({
        topic: {id: r.ka_topic.id, text: r.ka_topic.text},
        related_topic: {id: r.related_topic.id, text: r.related_topic.text},
        relation_type: r.rel_type,
      })
    end
    respond_to do |format|
      format.html { render "execute_amrr" }
      format.json { render json: @json_output }
    end
  end

  def execute_amrr
    TopicRelation.delete_all(:root_topic_id => params[:root_id])
    rel_type_mapping = ["Сильная", "Средняя", "Слабая"]

    topic = KaTopic.find(params[:root_id])
    root = topic.get_root #можно удалить, когда будет исправлено поле "params[:root_id]"
    topics = root.get_tree
    count = topics.count
    @rt = root

    @output = []
    @json_output = []
    ActiveRecord::Base.transaction do
      for i in 0..(count - 1)
        if !topics[i].nil?
          relation = TopicRelation.calculate_relation(topic, topics[i])
          puts(relation)
          if !relation.nil?
            relation.save
            @output.push({
              topic: relation.ka_topic.text,
              related_topic: relation.related_topic.text,
              relation_type: rel_type_mapping[relation.rel_type],
            })
            @json_output.push({
              topic: {id: relation.ka_topic.id, text: relation.ka_topic.text},
              related_topic: {id: relation.related_topic.id, text: relation.related_topic.text},
              relation_type: relation.rel_type,
            })
          end
        end
      end
    end

    respond_to do |format|
      format.html { }
      format.json { render json: @json_output }
    end
  end

  def show_topics_with_questions
    @root = KaTopic.find(params[:root_id])
    @topics = @root.get_tree
    @questions = @root.get_active_questions
  end

  def show_all_competences
    @root = KaTopic.find(params[:root_id])
    @topics = @root.get_tree
  end

  def show_all_constructs
    @root = KaTopic.find(params[:root_id])
    @topics = @root.get_tree
  end

  def show_general_constructs
    print "hello world"
  end

  private

  def load_quizzes
    @quizzes = []
    TestUtzTopic.ett_list.each do |ett_class|
      @quizzes += ett_class.all.map do |ett|
        { data: ett, type: ett_class.name.demodulize.underscore, label: ett_class.label }
      end
    end
  end
end
