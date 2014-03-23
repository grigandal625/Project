#coding utf-8
class TestController < ApplicationController
  layout 'test'
  helper :all
  before_action :check_student

  def get_task
    if session[:task_id] == nil
      @task = Task.first(offset: rand(Task.count))
    else
      @task = Task.find(session[:task_id])
    end
    session[:task_id] = @task.id
    session[:result_id] ||= 0
  end

  def next_component
    @task = Task.find(session[:task_id])
    result = Result.find_by_id(session[:result_id])
    if result == nil
      result = @task.results.create
      result.student = @user.student
      session[:result_id] = result.id
    end
    case params[:component]
    when 'start'
      render 'get_g'
    when 'V'
      if result.v_result == nil
        v_answer_bnf = JSON.parse(params[:answer_content])
        vresult = result.create_v_result
        vresult.create_bnf
        vresult.bnf.init_bnf(v_answer_bnf)
        vresult.create_log
        vresult.mark, vresult.log.data = @task.v_answer.check_answer(vresult.bnf)
      end
      render 'get_s'
    when 'G'
      if result.g_result == nil
        gresult = result.create_g_result
        gresult.answer = params[:g_answer]
        gresult.create_log
        gresult.mark, gresult.log.mistakes, gresult.log.data = @task.g_answer.check_answer(gresult.answer)
      end
      render 'get_v'
    when 'S'
      if result.s_result == nil
        sresult = result.create_s_result
        sresult.answer = params[:answer_content]
        sresult.mark = 0
        sresult.save
        sresult.mark = @task.s_answer.check_answer(sresult.answer)
        sresult.create_log(data: "")
        sresult.save
        redirect_to result_path(result)
      end
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
