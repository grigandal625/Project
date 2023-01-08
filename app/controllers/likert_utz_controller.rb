class LikertUtzController < ApplicationController
  before_action :check_admin, except: [:show]
  layout 'utz'

  def new
  end

  def show
    @utz = LikertUtz.find(params[:id])
    @tasks = LikertUtzTask.where(likert_utz: @utz)
    @variants = LikertUtzVariant.where(likert_utz: @utz)
  end

  def create
    x = params['topic_id']
    a = params
    
    tasks = params['tasks']
    variants = params['variants']
    matching = params['matching']

    utz = LikertUtz.create(name: "Задание " + (LikertUtz.count + 1).to_s, text: params['text'], ka_topic_id: params['topic_id'])
    
    tasks.each do |task|
      tsk = LikertUtzTask.create(likert_utz: utz, text: tasks[task]['text'])
      matching.each do |m|
        if matching[m]['task_id'] == tasks[task]['id']
          matching[m]['task'] = tsk
        end
      end
    end

    variants.each do |variant|
      vrt = LikertUtzVariant.create(likert_utz: utz, text: variants[variant]['text'])
      matching.each do |m|
        if matching[m]['variant_id'] == variants[variant]['id']
          matching[m]['variant'] = vrt
        end
      end
    end

    matching.each do |m|
      mc = LikertUtzMatch.create(likert_utz_task: matching[m]['task'], likert_utz_variant: matching[m]['variant'])
    end
    
  end

  def destroy
    LikertUtz.find(params[:id]).destroy
    redirect_to utz_path
  end
end
