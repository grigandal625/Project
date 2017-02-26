class PersonalityTestQuestionPicturesController < ApplicationController
  before_action :check_admin

  def create
    @picture = PersonalityTestQuestionPicture.create(image: params[:question_picture], personality_test_question_id: params[:question_id])
    render :create_or_update
  end

  def update
    @picture = PersonalityTestQuestionPicture.find(params[:id])
    @picture.update(image: params[:question_picture])
    render :create_or_update
  end
end
