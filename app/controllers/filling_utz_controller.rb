#coding=utf-8
class FillingUtzController < ApplicationController
  before_action :check_admin, except: :show
  layout 'utz'

  def new
  end

  def create
    level_dict = {'Легкий' => 1, 'Средний' => 2, 'Сложный' => 3}

    utz = FillingUtz.create name: 'Задание ' + (FillingUtz.count + 1).to_s, hint: params['hint'],
                            level: level_dict[params['level']],
                            text: params['text'],
                            ka_topic_id: params['topic_id']

    # selections = params['selections']

    # selections.each_value do |selection|
    #   interval = FillingUtzInterval.create start: selection['start'] , end: selection['end'],
    #                                        answer: selection['answer'], filling_utz_id: utz.id
    #   variants = selection['variants']

    #   variants.each { |variant| FillingUtzAnswer.create text: variant, filling_utz_interval_id: interval.id}
    # end

    elements = params['elements']

    elements.each_value do |element|
      e = FillingUtzElement.create(
        number: element['number'],
        text: element['text'],
        is_hidden: element['is_hidden'],
        filling_utz: utz
      )
    end

    render nothing: true
  end

  def show
    @utz = FillingUtz.find params[:id]
  end

  def detach
    FillingUtz.find(params[:q_id]).update(ka_topic_id: nil)

    redirect_to :back
  end

  def destroy
    FillingUtz.find(params[:id]).destroy
    redirect_to utz_path
  end
end
