#coding=utf-8
class TestUtzQuestionsController < ApplicationController
  before_action :check_admin, except: [:show, :check_answer]
  layout 'utz'
  def new
  end

  def create
    question = TestUtzQuestion.create text: params['question']

    answers = params['answers']

    answers.each_value do |answer|
      TestUtzAnswer.create text: answer['text'], is_correct: answer['correct'].to_bool, test_utz_question_id: question.id
    end

    render nothing: true
  end

  def show
    @question = TestUtzQuestion.find params[:id]
  end

  def check_answer
    question = TestUtzQuestion.find params[:id]

    correct_answers = question.answers.where(is_correct: true).map { |q| q.id.to_s }

    render text: (correct_answers.sort == params['checked_answers'].try(:sort) ? 'Верно' : 'Ошибка')
  end

  def destroy
    TestUtzQuestion.find(params[:id]).destroy
    redirect_to utz_path
  end
end
