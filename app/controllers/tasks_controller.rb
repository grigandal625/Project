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

  def get_task
    if session[:variant] == nil
      @task = Task.first(:offset => rand(Task.count))
      session[:variant] = @task.variant
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
      #render text: v_answer_bnf.inspect
      #return
      result = VResult.new
      result.create_bnf
      result.bnf.init_result_bnf(v_answer_bnf)
      #TODO result save and answer check
      render 'tasks/get_g'
    when 'G'
      render 'tasks/get_s'
    when 'S'
    end

  end

end
