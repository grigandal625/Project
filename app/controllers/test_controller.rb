#coding utf-8
class TestController < ApplicationController
  layout 'test'
  before_action :check_student

  def get_task
    @tasks = Task.all
  end

  def next_component
    if params[:component] == 'start'
      session[:task_id] = params[:task_id]
      session[:result_id] = 0
    end
    @task = Task.find(session[:task_id])
    result = Result.find_by_id(session[:result_id])
    if result == nil
      result = @task.results.create(results_mask: 0)
      result.create_g_result(mark: 0)
      result.g_result.create_log(data: "", mistakes: "")
      result.create_v_result(mark: 0)
      result.v_result.create_log(data: "", mistakes: "")
      result.create_s_result(mark: 0)
      result.s_result.create_log(data: "", mistakes: "")
      result.student = @user.student
      session[:result_id] = result.id
    end
    case params[:component]
    when 'start'
      render 'get_g'
    when 'V'
      if not result.has_v_result?
        result.results_mask |= 2
        v_answer_bnf = JSON.parse(params[:answer_content])
        result.v_result.create_bnf(bnf_json: Bnf.init_bnf(v_answer_bnf))
        result.v_result.create_log
        result.v_result.mark, result.v_result.log.data = @task.v_answer.check_answer(result.v_result.bnf)
      end
      render 'get_s'
    when 'G'
      if not result.has_g_result?
        result.results_mask |= 1
        result.g_result.answer = params[:g_answer]
        result.g_result.create_log
        result.g_result.mark,
          result.g_result.log.mistakes,
          result.g_result.log.data =
          @task.g_answer.check_answer(result.g_result.answer)
      end
      render 'get_v'
    when 'S'
      if !result.has_s_result?
        result.results_mask |= 4
        result.s_result.answer = params[:answer_content]
        result.s_result.create_log
        result.s_result.mark,
          result.s_result.log.mistakes,
          result.s_result.log.data =
          @task.s_answer.check_answer(result.s_result.answer)
      end
      redirect_to result_path(result)
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
