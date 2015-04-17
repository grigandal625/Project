class KaResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"
  
  def index
  end

  def show
    test_id = params[:test_id]
    @test = KaTest.find(test_id)
  end

  def detail
    result_id = params[:result_id]
    @result = KaResult.find(result_id)
    @student = @result.user.student
  end
end
