class KaVariantsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"

  def check
    variant = KaVariant.find(params[:id])
    @assessment = 0
    answers = {}
    params.each do |key, value|
      if key.include? "answer_id:"
        answers[key["answer_id:".length...key.length + 1]] = 1
      end
    end
    right = {}
    wrong = {}
    questions = variant.ka_question.each
    questions.each do |q|
      right[q.id] = 1.0 / q.ka_answer.where(correct: 1).count
      wrong[q.id] = 1.0 / q.ka_answer.where(correct: 0).count
      if right[q.id] > wrong[q.id]
        wrong[q.id] = right[q.id]
      end
    end
    answers.each do |a, _buf|
      ans = KaAnswer.find(a)
      if ans.correct != 0
        @assessment += right[ans.ka_question_id]
      else
        @assessment -= wrong[ans.ka_question_id]
      end
    end
    @assessment /= 1.0 * questions.count
    @assessment *= 100.0
    if @assessment < 0
      @assessment = 0.0
    end
    @assessment = @assessment.to_i
    result = KaResult.new
    result.ka_variant_id = variant.id
    result.user_id = @user.id
    result.assessment = @assessment
    result.save
    answers.each do |a, _buf|
      answer_log = KaAnswerLog.new
      answer_log.ka_result_id = result.id
      answer_log.ka_answer_id = a
      answer_log.save
    end
  end
end
