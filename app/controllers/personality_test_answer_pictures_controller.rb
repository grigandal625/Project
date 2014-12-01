class PersonalityTestAnswerPicturesController < ApplicationController
  before_action :check_admin

  def create
    @picture = PersonalityTestAnswerPicture.create(image: params[:answer_picture], personality_test_answer_id: params[:answer_id])
    render :create_or_update
  end

  def update
    @picture = PersonalityTestAnswerPicture.find(params[:id])
    @picture.update(image: params[:answer_picture])
    render :create_or_update
  end
end