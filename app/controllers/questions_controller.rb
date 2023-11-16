class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_client!
  before_action :find_survey!
  before_action :find_question!, :only => [:edit, :update, :destroy, :duplicate]

  def index
    @questions = @survey.questions

    if params[:sort].present?
      case params[:sort]
      when 'position'
        @order = toggle_order(params[:sort])
        @questions = @questions.unscoped.order(position: @order)
      else
        @questions
      end
    end
  end

  def new
    @question_form = QuestionForm.new(client: @client, survey: @survey)
  end

  def create
    form_params = question_params.merge(client: @client, survey: @survey)

    save_and_redirect(form_params, :new)
  end

  def edit
    @question_form = QuestionForm.new(:question => @question)
  end

  def update
    form_params = question_params.merge(:question => @question)
    save_and_redirect(form_params, :edit)
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to index_location }
      format.js
    end
  end

  def duplicate
    new_question = @question.dup
    new_question.position = @survey.last_position_number + 10
    new_question.question_text = @question.question_text.dup
    new_question.question_text_1 = @question.question_text_1.dup
    if new_question.save
      flash[:notice] = "Question duplicated successfully."
      redirect_to edit_client_survey_question_path(@client, @survey, new_question)
    else
      flash[:notice] = "Failed to duplicate question."
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def save_and_redirect(form_params, on_error_key)
    if params[:multiple_select_question].present?
      questions_split = QuestionTextSplit.new(form_params)

      questions_split.questions.each do |question|
        @question_form = QuestionForm.new(question)
        @question_form.save

        if @question_form.errors.present?
          respond_to do |format|
            format.html { render on_error_key.to_sym }
            format.js
          end
        end
      end
    else
      @question_form = QuestionForm.new(form_params)
      @question_form.save

      if @question_form.errors.present?
        respond_to do |format|
          format.html { render on_error_key.to_sym }
          format.js
        end
      end
    end

    if @question_form.errors.empty?
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end
  end

  def find_client!
    @client = Client.find(params[:client_id])
  end

  def find_survey!
    if @client.present?
      @survey = @client.surveys.find(params[:survey_id])
    else
      @survey = Survey.find(params[:survey_id])
    end
  end

  def find_question!
    @question = @survey.questions.find(params[:id])
  end

  def index_location
    client_survey_questions_url(@client, @survey)
  end

  def question_params
    params.require(:question).permit!
  end
end
