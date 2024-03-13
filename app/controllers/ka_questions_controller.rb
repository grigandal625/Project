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
        if correct == 'on'
          correct = 1
        else
          correct = 0
        end
        a = KaAnswer.new
        a.ka_question_id = question.id
        a.text = text
        a.correct = correct
        a.save
        c = c + 1
      end
    end
    redirect_to :back
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
    redirect_to :back
  end

  def index
  end

  def show
    @question = KaQuestion.find(params[:id])
  end

  def destroy
    question = KaQuestion.find(params[:id])
    if question
      question.destroy
    end
    redirect_to :back
  end
end
