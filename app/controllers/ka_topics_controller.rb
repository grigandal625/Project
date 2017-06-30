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
          state: 1)
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Построение онтологии курса/дисциплины"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if((pddl_act == "execute-development-step") && (leaf_id == "onthology-development-step"))
        return {"controller" => "ka_topics", "params" => {}}
      else
        return {}
      end
    }

    return ext
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: KaTopic.find(params[:id]).get_tree }
    end
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
    @topics_utz = [@topic]
    topic = @topic.clone
    until topic.parent_id.nil?
      topic = KaTopic.find(topic.parent_id).clone
    end
    unless(@topic.id == topic.id)
      @topics_utz << topic
    end
    @competences = Competence.all
    if (session[:planning_task_id]!=nil)
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
    type = params[:ka_topic_id].split(',')[0].to_i
    ka_topic_id = params[:ka_topic_id].split(',')[1].to_i
    case type
      when 1
        TestUtzQuestion.find(ka_topic_id).update(ka_topic_id: params[:id])
      when 2
        MatchingUtz.find(ka_topic_id).update(ka_topic_id: params[:id])
      when 3
        FillingUtz.find(ka_topic_id).update(ka_topic_id: params[:id])
      when 4
        TextCorrectionUtz.find(ka_topic_id).update(ka_topic_id: params[:id])
      when 5
        ImagesSortUtz.find(ka_topic_id).update(ka_topic_id: params[:id])
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

	def execute_amrr
	  root = KaTopic.find(params[:root_id])
	  topics = root.get_tree
	  constructs = root.constructs
	  @output = []
	  rel_type_mapping = ["Сильная", "Средняя", "Слабая"]

	  ActiveRecord::Base.transaction do
	    for i in 0..(topics.count - 2)
	      for j in (i+1)..(topics.count - 1)
		relation = TopicRelation.calculate_relation(topics[i], topics[j], constructs)
		relation.save
		@output.push({topic: topics[i].text, related_topic: topics[j].text, relation_type: rel_type_mapping[relation.rel_type]})
	      end
	    end
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

  private
    def load_quizzes
      @quizzes = []
      TestUtzQuestion.all.each do |q|
        @quizzes.push( { type: 1, data: q,  })
      end
      MatchingUtz.all.each do |q|
        @quizzes.push( { type: 2, data: q })
      end
      FillingUtz.all.each do |q|
        @quizzes.push( { type: 3, data: q })
      end
      TextCorrectionUtz.all.each do |q|
        @quizzes.push( { type: 4, data: q })
      end
      ImagesSortUtz.all.each do |q|
        @quizzes.push( { type: 5, data: q })
      end
    end
end
