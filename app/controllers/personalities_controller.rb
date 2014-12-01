class PersonalitiesController < ApplicationController
  layout 'personality_tests'
  before_action :check_admin

  def index
    @personalities = Personality.all
    @traits = PersonalityTrait.all
  end

  def new
    respond_to do |format|
      format.js {
        #TODO: заменить traits на trait
        @personality = Personality.create name: 'Новый психологический портрет', description: 'Оисание',
                                          personality_trait_id: PersonalityTrait.first.try(:id),
                                          begin_at: 1, end_at: 2
        @traits = PersonalityTrait.all
      }
    end
  end

  def update
    Personality.find(params[:id]).update(params[:name] => params[:value])
    render nothing: true
  end

  def destroy
    respond_to do |format|
      format.js {
        Personality.find(params[:id]).destroy
      }
      format.any
    end
  end
end
