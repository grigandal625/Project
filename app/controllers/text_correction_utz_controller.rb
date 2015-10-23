#coding=utf-8
class TextCorrectionUtzController < ApplicationController
  before_action :check_admin, except: [:show, :check_answer]
  layout 'utz'
  def new
  end

  def create
    TextCorrectionUtz.create name: 'Задание ' + (TextCorrectionUtz.count + 1).to_s,
                       errors_count: params[:errors_count],
                       text_with_errors: params[:text_with_errors],
                       text_without_errors: params[:text_without_errors],
                       hint: ( params[:hint] == 'Введите подсказку' ? '' : params[:hint] ),
                       ka_topic_id: params[:topic_id]

    render nothing: true
  end

  def show
    @utz = TextCorrectionUtz.find params[:id]
  end

  def check_answer
    utz = TextCorrectionUtz.find params[:id]
    render text: (utz.text_without_errors == params[:answer] ? 'Верно' : 'Ошибка')
  end

  def destroy
    TextCorrectionUtz.find(params[:id]).destroy
    redirect_to utz_path
  end
end
