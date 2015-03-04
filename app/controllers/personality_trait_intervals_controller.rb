class PersonalityTraitIntervalsController < ApplicationController
  def new
    respond_to do |format|
      format.js { @interval = PersonalityTraitInterval.create(begin_at:0, end_at: 1, personality_id: params[:personality_id], personality_trait_id: PersonalityTrait.first) }
    end
  end

  def update
    PersonalityTraitInterval.find(params[:id]).update(params[:name] => params[:value])
    render nothing: true
  end

  def destroy
    respond_to do |format|
      format.js {
        PersonalityTraitInterval.find(params[:id]).destroy
      }
      format.any
    end
  end
end
