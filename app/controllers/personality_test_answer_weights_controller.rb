class PersonalityTestAnswerWeightsController < ApplicationController
  before_action :check_admin

  def new
    respond_to do |format|
      format.js {
        answer = PersonalityTestAnswer.find(params[:answer_id])
        trait = PersonalityTrait.where.not(id: answer.traits.pluck(:id)).first
        trait = PersonalityTrait.first unless trait

        if trait
          @traits = PersonalityTrait.all
          @weight = PersonalityTestAnswerWeight.create value: 0,
                                                       personality_trait_id: trait.id,
                                                       personality_test_answer_id: answer.id
        end
      }
    end
  end

  def update
    PersonalityTestAnswerWeight.find(params[:id]).update(params[:name] => params[:value])
    render nothing: true
  end

  def destroy
    respond_to do |format|
      format.js {
        PersonalityTestAnswerWeight.find(params[:id]).destroy
      }
      format.any
    end
  end
end
