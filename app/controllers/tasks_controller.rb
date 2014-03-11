class TasksController < ApplicationController
  layout 'task'

#temp shit
  def get_v
    @task = Task.find_by(variant: 1)
  end

  def get_g
    @task = Task.find_by(variant: 1)
  end

  def get_s
    @task = Task.find_by(variant: 1)
  end
#temp shit

  def new
  end

  def create
    sentences = params[:sentences].split("\r\n")
    render text: sentences.inspect #temp shit
  end

  def get_task
    if session[:variant] == nil
      @task = Task.first(:offset => rand(Task.count))
      session[:variant] = @task.variant
      session[:result_id] = Result.create
    else
      @task = Task.find_by(variant: session[:variant])
    end
    render 'tasks/get_v'
  end

  def next_component
    @task = Task.find_by(variant: session[:variant])
    case params[:component]
    when 'V'
      v_answer_bnf = JSON.parse(params[:v_answer_bnf])
      result = Result.find(session[:result_id])
      vresult = result.create_v_result
      vresult.create_bnf
      vresult.bnf.init_bnf(v_answer_bnf)
      vresult.mark = @task.v_answer.check_answer(vresult.bnf)
      vresult.save
      result.save
      render 'tasks/get_g'
    when 'G'
      render 'tasks/get_s'
    when 'S'
    end

  end

end
