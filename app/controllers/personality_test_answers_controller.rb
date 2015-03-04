#coding=utf-8
class PersonalityTestAnswersController < ApplicationController
  before_action :check_admin

  def new
      respond_to do |format|
          format.js {
            # TODO: Почему не работает case?
            # case params["create_answers"]
            #   when "yes/no"
            #     @answers = [PersonalityTestAnswer.create_or_update( value: 'Да',
            #                                              personality_test_question_id: params[:question_id]),
            #                 PersonalityTestAnswer.create_or_update( value: 'Нет',
            #                                              personality_test_question_id: params[:question_id])]
            #   when "yes/no/no matter"
            #     @answers = [PersonalityTestAnswer.create_or_update( value: 'Да',
            #                                               personality_test_question_id: params[:question_id]),
            #                 PersonalityTestAnswer.create_or_update( value: 'Нет',
            #                                               personality_test_question_id: params[:question_id]),
            #                 PersonalityTestAnswer.create_or_update( value: 'Не знаю',
            #                                               personality_test_question_id: params[:question_id])]
            #   else
            #     @answers = [PersonalityTestAnswer.create_or_update value: 'Новый вариант ответа',
            #                                                  personality_test_question_id: params[:question_id]]
            #   end
            if params[:create_answers] == 'yes/no'
                @answers = [PersonalityTestAnswer.create( value: 'Да',
                                                          personality_test_question_id: params[:question_id]),
                            PersonalityTestAnswer.create( value: 'Нет',
                                                          personality_test_question_id: params[:question_id])]
            elsif params[:create_answers] == 'yes/no/no matter'
                @answers = [PersonalityTestAnswer.create( value: 'Да',
                                                          personality_test_question_id: params[:question_id]),
                            PersonalityTestAnswer.create( value: 'Нет',
                                                          personality_test_question_id: params[:question_id]),
                            PersonalityTestAnswer.create( value: 'Не знаю',
                                                          personality_test_question_id: params[:question_id])]
            else
                @answers = [PersonalityTestAnswer.create(value: 'Новый вариант ответа',
                                                         personality_test_question_id: params[:question_id])]
            end
          }
          format.any
      end
  end

  def update
    respond_to do |format|
      format.js {
        @answer = PersonalityTestAnswer.find(params[:id])
        @answer.update(value: params['value'])
      }
      format.any
    end
  end

  def destroy
    respond_to do |format|
      format.js {
        PersonalityTestAnswer.find(params[:id]).destroy
      }
      format.any
    end
  end
end
