class TasksController < ApplicationController
  layout 'task'

#temp shit
  def get_v
    @task = Task.find(1)
  end

  def get_g
    @task = Task.find(1)
  end

  def get_s
    @task = Task.find(1)
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
      session[:task_id] = @task.id
      session[:result_id] = Result.create
    else
      @task = Task.find(session[:task_id])
    end
    render 'tasks/get_v'
  end

  def next_component
    @task = Task.find(session[:task_id])
    result = Result.find(session[:result_id])
    case params[:component]
    when 'V'
      v_answer_bnf = JSON.parse(params[:v_answer_bnf])
      vresult = result.create_v_result
      vresult.create_bnf
      vresult.bnf.init_bnf(v_answer_bnf)
      vresult.mark = @task.v_answer.check_answer(vresult.bnf)
      vresult.save
      render 'tasks/get_g'
    when 'G'
      gresult = result.create_g_result
      gresult.answer = params[:g_answer]
      gresult.mark = @task.g_answer.check_answer(gresult.answer)
      gresult.save
      render 'tasks/get_s'
    when 'S'
    end
    result.save
  end

end
