class PersonalityTestQuestionsController < ApplicationController
  before_action :check_admin

  def new
    respond_to do |format|
      format.js {
        max_order = PersonalityTest.find(params[:test_id]).questions.maximum(:ordering)
        @question = PersonalityTestQuestion.create value: 'Новый вопрос',
                                                   ordering: max_order ? max_order + 1 : 1,
                                                   personality_test_question_type_id: PersonalityTestQuestionType.first.try(:id)
        PersonalityTest.find(params[:test_id]).questions << @question
        @types = PersonalityTestQuestionType.all
      }
      format.any
    end
  end

  def edit
    respond_to do |format|
      format.js {
        @question = PersonalityTestQuestion.find(params[:id])
        @types = PersonalityTestQuestionType.all
        @traits = PersonalityTrait.all

      }
      format.any
    end
  end

  def show
    respond_to do |format|
      format.js {
        @question = PersonalityTestQuestion.find(params[:id])
      }
    end
  end

  def update
    @question = PersonalityTestQuestion.find(params[:id])
    @question.update(params['name'] => params['value'])
  end

  def batch_update
    params[:order].each_with_index do |id, index|
      PersonalityTestQuestion.find(id).update(ordering: index + 1)
    end
    render nothing: true
  end

  def destroy
    PersonalityTestQuestion.find(params[:id]).destroy
  end
end
