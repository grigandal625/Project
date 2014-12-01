class PersonalityTestsController < ApplicationController
  layout 'personality_tests'
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy]
  def index
    @tests = PersonalityTest.all
  end

  def new
    respond_to do |format|
      format.js {
        @test = PersonalityTest.create name: 'Новый тест', personality_test_type_id: PersonalityTestType.first.try(:id)

        @types = PersonalityTestType.all
      }
      format.any
    end
  end

  def create
    @test = PersonalityTest.new(test_params)

    if @test.save
      redirect_to action: :index
    else
      flash[:error] = 'Невозможно создать запись'
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.js {
        @test = PersonalityTest.find(params[:id])
        @types = PersonalityTestType.all
      }
      format.any
    end
  end

  def update
    respond_to do |format|
      format.js {
        @test = PersonalityTest.find(params[:id])
        @test.update(params['name'] => params['value'])
      }
      format.any
    end
  end

  def destroy
    @test = PersonalityTest.find params[:id]
    @test.destroy

    redirect_to action: :index
  end

  def show
    @test = PersonalityTest.find(params[:id])
    @current_time = Time.now
    session[:test_start_time] = @current_time
    session[:current_test] = @test.id

  end

  def save_results
    test = PersonalityTest.find(params[:id])
    student = @user.student

    student.passed_personality_tests << test if student

    score = {}

    test.questions.each do |question|
      answers_id = params[question.id.to_s]
      if answers_id
        #TODO: убрать id
        case question.type.id
          when 1
            PersonalityTestAnswer.find(answers_id).weights.each do |weight|
              score[weight.trait.id] ? score[weight.trait.id] += weight.value : score[weight.trait.id] = weight.value
            end
          when 2
            answers_id.each do |id|
              PersonalityTestAnswer.find(id).weights.each do |weight|
                score[weight.trait.id] ? score[weight.trait.id] += weight.value : score[weight.trait.id] = weight.value
              end
            end
          when 3
            length = answers_id.size - 1
            answers_id.each_with_index do |id, index|
              PersonalityTestAnswer.find(id).weights.each do |weight|
                score[weight.trait.id] ? score[weight.trait.id] += (weight.value * 10**(length - index)) : score[weight.trait.id] = weight.value * 10**(length - index)
              end
            end
          when 4
            length = answers_id.size
            answers_id.each_with_index do |id, index|
              PersonalityTestAnswer.find(id).weights.each do |weight|
                score[weight.trait.id] ? score[weight.trait.id] += (weight.value * (length - index) ) : score[weight.trait.id] = weight.value * (length - index)
              end
            end
        end
      end
    end
    logger.debug score
    @personalities = []

    if test.type.name == 'max'
      id = score.max_by{|k,v| v}[0]
      trait = PersonalityTrait.find(id)
      if trait.name == 'Думающий'
        score.delete(id)
        trait = PersonalityTrait.find(score.max_by{|k,v| v}[0])
      else
        PersonalityTrait.find(score.max_by{|k,v| v}[0]).personalities.each do |personality|
          @personalities.push personality
          student.personalities << personality if student
        end
      end
    else
      score.each do |id, value|
        logger.debug ((Time.now - session[:test_start_time]).to_i / 60).to_f

        if test.type.name == 'поделить на время'
          minutes = (Time.now - session[:test_start_time]).min + 1
          value /= minutes
        end
        PersonalityTrait.find(id).personalities.each do |personality|
          if value >= personality.begin_at && value <= personality.end_at
            @personalities.push personality
            student.personalities << personality if student
          end
        end
      end
    end
  end

  def results
    student = @user.student
    if student
      @personalities = student.personalities
    end
  end
end
