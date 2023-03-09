class AttemptsController < ApplicationController
  before_action :find_survey!
  before_action :find_attempt!
  before_action :find_client!
  before_action :set_step!

  def show
    # @attempt = @survey.attempts.find_by(attempt_params_for_find)
  end

  def new
    @attempt_builder = AttemptBuilder.new(attempt_params)
  end

  def create
    @attempt_builder = AttemptBuilder.new(attempt_params)
    
    if @attempt_builder.save
      
      if @attempt_builder.attempt.completed
        redirect_to after_answer_path_for
      else
        redirect_to edit_attempt_flath_path(id: @attempt_builder.attempt.id, step: @attempt_builder.step.to_i + 1)
      end
    else
      render :new
    end
  end

  def edit
    @attempt_builder = AttemptBuilder.new(attempt_params.merge(action: "update"))
  end

  def update
    @attempt_builder = AttemptBuilder.new(attempt_params)

    if @attempt_builder.save
      # @attempt_builder.attempt.save!
      if @attempt_builder.attempt.completed
        redirect_to after_answer_path_for
      else
        redirect_to edit_attempt_flath_path(id: @attempt_builder.attempt.id, step: @attempt_builder.step.to_i + 1)
      end
    else
      render :edit
    end
  end

  private
  def find_client!
    @client = @survey.client
  end

  def find_survey!
    @survey = Survey.find(params[:survey_id])
  end

  def find_attempt!
    @attempt = params[:id].present? ? Attempt.find(params[:id]) : Attempt.new
  end

  def set_step!
    @step = params[:step]
  end


  def attempt_params
    answer_params = { params: (params[:attempt_builder] || {}) }
    answer_params.merge(survey: @survey, attempt: @attempt, attempt_id: params[:id], step: @step)
  end

  # def attempt_params_for_find
  #   these_params = attempt_params
  #   these_params.delete(:step)
  #   these_params[:id] = these_params.delete(:attempt_id)
  #   these_params
  # end

  # Override path to redirect after answer the survey
  # Write:
  #   # my_app/app/decorators/controllers/rapidfire/attempts_controller_decorator.rb
  #   Rapidfire::AttemptsController.class_eval do
  #     def after_answer_path_for
  #       main_app.root_path
  #     end
  #   end
  def after_answer_path_for
    if @survey.conclusion.present?
      client_survey_attempt_path(@survey.client, @survey, @attempt_builder.to_model)
    else
      surveys_path
    end
  end

  # def current_scoped
  #   send 'current_' + rapidfire_scoped.to_s
  # end
end

