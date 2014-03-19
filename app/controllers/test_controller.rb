#coding utf-8
class TestController < ApplicationController
  layout 'test'
  helper :all
  before_action :check_student

#temp shit
  def get_s
    @task = Task.find(1)
  end
#temp shit

  def get_task
    if session[:task_id] == nil
      @task = Task.first(offset: rand(Task.count))
    else
      @task = Task.find(session[:task_id])
    end
    session[:task_id] = @task.id
    result = @task.results.create
    result.student = @user.student
    result.save
    session[:result_id] = result.id
    render 'get_g'
  end

  def next_component
    @task = Task.find(session[:task_id])
    result = Result.find(session[:result_id])
    case params[:component]
    when 'V'
      v_answer_bnf = JSON.parse(params[:answer_content])
      vresult = result.create_v_result
      vresult.create_bnf
      vresult.bnf.init_bnf(v_answer_bnf)
      vresult.mark = @task.v_answer.check_answer(vresult.bnf)
      vresult.save
      render 'get_s'
    when 'G'
      gresult = result.create_g_result
      gresult.answer = params[:g_answer]
      gresult.mark = @task.g_answer.check_answer(gresult.answer)
      gresult.save
      render 'get_v'
    when 'S'
    end
    result.save
  end

  private
  def check_student
    if @user.role != 'student'
      render status: :forbidden,
        text: "You aren't allowed to see this page<br/><a href=#{tasks_path}>Admin tools</a>"
    end
  end

end
