class KaResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"
  
  def index
  end

  def show
    test_id = params[:test_id]
    @test = KaTest.find(test_id)
  end

  def recalc
    test_id = params[:id]
    test = KaTest.find(test_id)

    test.ka_results.each do |r|
      answers = []
      r.ka_answer_logs.each do |al|
        answers.push(al.ka_answer_id)
      end
      variant = r.ka_variant
      detail_result = KaDetailResult.new(variant, answers)
      r.assessment = detail_result.assessment
      r.save
    end

    redirect_to :back
  end

  def detail
    result_id = params[:result_id]
    @result = KaResult.find(result_id)
    @student = @result.user.student

    answers = []
    @result.ka_answer_logs.each do |al|
      answers.push(al.ka_answer_id)
    end

    @detail_result = KaDetailResult.new(@result.ka_variant, answers)
  end
end
