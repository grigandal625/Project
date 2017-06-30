#coding=utf-8
class MatchingUtzController < ApplicationController
  before_action :check_admin, except: [:show, :check_answers]
  layout 'utz'
  def create
    level_dict = {'Легкий' => 1, 'Средний' => 2, 'Сложный' => 3}
    utz = MatchingUtz.create name: "Задание " + (MatchingUtz.count + 1).to_s, level: level_dict[params['level']],
                          hint: params['hint'], ka_topic_id: params[:topic_id]
    left = params['left']
    right = params['right']

    left.each_with_index do |value, index|
      question = MatchingUtzQuestion.create text: value, matching_utz_id: utz.id
      MatchingUtzAnswer.create text: right[index], matching_utz_question_id: question.id
    end

    render nothing: true
  end

  def new
  end

  def show
    @utz = MatchingUtz.find params[:id]
    @questions = MatchingUtzQuestion.where matching_utz_id: @utz.id
    @answers = MatchingUtzAnswer.where(matching_utz_question_id: @questions.ids).order("RANDOM()")
  end

  def destroy
    MatchingUtz.find(params[:id]).destroy
    redirect_to utz_path
  end

  def detach
    MatchingUtz.find(params[:q_id]).update(ka_topic_id: nil)

    redirect_to :back
  end

  #TODO: переписать с использованием right
  def check_answers
    questions = MatchingUtzQuestion.where matching_utz_id: params[:id]
    msg = "Все верно"
    right = params['right']

    questions.each_with_index do |question, index|
      if question.answer.text != right[index]
        msg = 'Ошибка'
        break
      end
    end

    render text: msg
  end
end
