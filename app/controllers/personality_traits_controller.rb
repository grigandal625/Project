class PersonalityTraitsController < ApplicationController
  layout 'personality_tests'
  before_action :check_admin

  def index
    @traits = PersonalityTrait.all
  end

  def new
    respond_to do |format|
      format.js {
        @trait = PersonalityTrait.create name: 'Новая черта характера'
      }
      format.any
    end
  end

  def update
    PersonalityTrait.find(params[:id]).update(params[:name] => params[:value])
    render nothing: true
  end

  def destroy
    respond_to do |format|
      format.js {
        PersonalityTrait.find(params[:id]).destroy
      }
      format.any
    end
  end
end
