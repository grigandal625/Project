class KaQuestionsController < ApplicationController
  before_action :check_admin
  skip_before_filter :verify_authenticity_token
  layout "ka_application"

  def new
    if params[:topic_id] and params[:difficulty]
      question = KaQuestion.new
      question.ka_topic_id = params[:topic_id]
      question.text = params[:text]
      question.difficulty = params[:difficulty].to_i
      question.save
      c = 0
      while params.has_key?(('answer_' + c.to_s + '_text').to_sym)
        text = params[('answer_' + c.to_s + '_text').to_sym]
        correct = params[('answer_' + c.to_s + '_correct').to_sym]

        if correct.class == String
          if correct == 'on'
            correct = 1
          else
            correct = 0
          end
        end
        a = KaAnswer.new
        a.ka_question_id = question.id
        a.text = text
        a.correct = correct
        a.save
        c = c + 1
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: question.as_json(include: :ka_answer) }
    end
  end

  def edit
    question = KaQuestion.find(params[:id])
    if question and params[:text] and params[:difficulty]
      question.text = params[:text]
      question.difficulty = params[:difficulty]
      question.disable = 0
      if params[:disable] and params[:disable] = "on"
        question.disable = 1
      end
      question.save
    end
    if params.has_key?(:answers)
      KaAnswer.where(ka_question_id: params[:id]).destroy_all
      params[:answers].each do |answer|
        correct = answer[:correct]
        if correct.nil?
          correct = false
        end
        a = KaAnswer.new(ka_question: question, text: answer[:text], correct: correct)
        a.save
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: question.as_json(include: :ka_answer) }
    end
  end

  def index
  end

  def show
    @question = KaQuestion.find(params[:id])
    respond_to do |format|
      format.html { }
      format.json { render json: @question.as_json(include: :ka_answer) }
    end
  end

  def destroy
    question = KaQuestion.find(params[:id])
    if question
      question.destroy
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: params }
    end
  end
end
