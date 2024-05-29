class AnswersController < ApplicationController
  before_action :find_answers!
  def index
    respond_to do |format|
      format.json { render json: @answers }
    end
  end

  private

  def find_answers!
    survey = Survey.find(params[:survey_id])
    @answers = Answer.joins(question: :survey)
      .where(surveys: { id: survey.id }, questions: { id: params[:question_id] })
      .distinct.pluck(:answer_text)
  end
end
