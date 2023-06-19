class KaTestsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin
  skip_before_filter :check_admin, only: [:run]

  layout "ka_application"
  
  def new
    topics_root = []
    topics_tree = {}
    topics_all = {}
    topics_db = KaTopic.all
    
    topics_db.each do |t|
      topics_all[t.id] = t
    end
    
    topics_db.each do |t|
      topics_tree[t.id] = []
      if not t.parent_id
        topics_root.push(t.id)
      end
    end

    topics_db.each do |t|
      if t.parent_id
        topics_tree[t.parent_id].push(t.id)
      end
    end

    @topics = []
    topics_root.each do |root|
      generate_tree(root, 0, topics_tree, topics_all, @topics)
    end
  end

  def destroy
    test = KaTest.find(params[:id])
    if test
      test.destroy
    end
    redirect_to :back
  end

  def index
  end

  def show
    @test = KaTest.find(params[:id])
  end

  def edit
    tests = {}
    params.each do |key, value|
      if key.include? "test_id:"
        s = key["test_id:".length...key.length]
        tests[s.to_i] = 1
      end
    end

    KaTest.find_each do |t|
      if tests[t.id]
        t.on = 1
      else
        t.on = 0
      end
      t.save
    end

    redirect_to :back
  end

  def save
    tops = []
    params.each do |key, value|
      if key.include? "topic_id:"
        s = key["topic_id:".length...key.length]
        if KaTopic.find(s.to_i).ka_question.count > 0
          tops.push(s.to_i)
        end
      end
    end

    config = TasksGenerator::Config.new
    config.variants_count = params[:variants_count].to_i
    config.questions_count = params[:questions_count].to_i
    config.topics = tops
    # if params[:write_gen_test_config] == "true"
    File.open(Rails.root.to_s + "/tmp/output/config.txt", "w") do |file|
      # write data to file
      file.write(config.variants_count)
      file.write("\n")
      file.write(config.questions_count)
      file.write("\n")
      config.topics.each do |t|
        file.write(t)
        file.write("\n")
      end
    end
    # end

    topics = []
    File.open(Rails.root.to_s + "/tmp/output/topics.txt", "w") do |file|
      KaTopic.find_each do |t|
        topic_id = t.id
        parent_id = t.parent_id ? t.parent_id : 0
        text = t.text
        file.write(topic_id)
        file.write("\n")
        file.write(parent_id)
        file.write("\n")
        file.write(text)
        file.write("\n")
        topics.push(TasksGenerator::Topic.new(topic_id, parent_id, text))
      end
    end

    if not topics
      redirect_to :back
      return
    end

    questions = []
    File.open(Rails.root.to_s + "/tmp/output/questions.txt", "w") do |file|
      KaQuestion.find_each do |q|
        if q.disable == 0
          question_id = q.id
          topic_id = q.ka_topic_id
          difficulty = q.difficulty
          text = q.text
          file.write(question_id)
          file.write("\n")
          file.write(topic_id)
          file.write("\n")
          file.write(difficulty)
          file.write("\n")
          file.write(text)
          file.write("\n")
          questions.push(TasksGenerator::Question.new(question_id, topic_id, difficulty, text))
        end
      end
    end

    generator = TasksGenerator::Generator.new(config, topics, questions)

    variants = generator.generate()

    test = KaTest.new
    test.text = params[:name]
    test.questions_count = params[:questions_count]
    test.variants_count = params[:variants_count]
    test.minutes = params[:minutes_count]
    test.save
    number = 1
    variants.each do |var|
      variant = KaVariant.new
      variant.ka_test_id = test.id
      variant.number = number
      variant.save
      var.each do |q|
        variant_question = KaQuestionsVariants.new
        variant_question.ka_variant_id = variant.id
        variant_question.ka_question_id = q.question_id
        variant_question.save
      end
      number += 1
    end

    redirect_to ka_tests_path
  end

  def run
    @test = KaTest.find(params[:id])
    if not @test
      redirect_to :back and return
    end
    # TODO: Check current test is running
    @variant = KaVariant.find_by(ka_test_id: @test.id, number: rand(@test.variants_count) + 1)
    @variants = @variant.ka_question.shuffle
    @questions = []
    @variants.each do |v|
      @questions.push([@questions.length + 1, v, v.ka_answer.shuffle])
    end
  end

  def topics_list(topic_id)
    topics = []
    while topic_id do
      topics.push(topic_id)
      topic = KaTopic.find(topic_id)
      if not topic
        break
      end
      topic_id = topic.parent_id
    end
    s = ""
    topics = topics.reverse
    for i in 0..topics.size
      s += topics[i].to_s
      if i + 1 <  topics.size
        s += "."
      end
    end
    return s
  end

  helper_method :topics_list

  private
  def generate_tree(topic_id, step, topics_tree, topics_all, topics)
    topics.push([step, topics_all[topic_id]])
    if step < 3
      topics_tree[topic_id].each do |t|
        generate_tree(t, step + 1, topics_tree, topics_all, topics)
      end
    end
  end
end
