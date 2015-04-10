class KaQuestionsController < ApplicationController
  before_action :check_admin
  skip_before_filter :verify_authenticity_token
  layout "ka_application"

  def new
    if params[:topic_id] and params[:difficulty]
      question = KaQuestion.new
      question.ka_topic_id = params[:topic_id]
      question.text = params[:text]
      question.difficulty = params[:difficulty]
      question.save
    end
    redirect_to :back
  end

  def edit
    question = KaQuestion.find(params[:id])
    if question and params[:text] and params[:difficulty]
      question.text = params[:text]
      question.difficulty = params[:difficulty]
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
