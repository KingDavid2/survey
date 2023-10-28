class AttemptsController < ApplicationController
  before_action :find_client!, except: :over
  before_action :find_survey!, except: :over
  before_action :find_attempt!, except: :over
  before_action :set_step!, except: :over
  before_action :set_submit_text!, except: :over

  def show
    # @attempt = @survey.attempts.find_by(attempt_params_for_find)
  end

  def new
    if @survey.active?
      @attempt_builder = AttemptBuilder.new(attempt_params)
    else
      redirect_to over_path
    end
  end

  def create
    @attempt_builder = AttemptBuilder.new(attempt_params)
    
    if @attempt_builder.save
      
      if @attempt_builder.attempt.completed
        redirect_to after_answer_path_for
      else
        redirect_to edit_attempt_flat_path(id: @attempt_builder.attempt.id, step: @attempt_builder.step.to_i + 1)
      end
    else
      render :new
    end
  end

  def edit
    @attempt_path = edit_attempt_flat_url(id: params[:id], step: @step ) if params[:saved].present?
    @attempt_builder = AttemptBuilder.new(attempt_params.merge(action: "update"))
  end

  def update
    if params[:save]
      @attempt_builder = AttemptBuilder.new(attempt_params)
      @attempt_builder.save(validate: false)

      redirect_to edit_attempt_flat_path(id: @attempt_builder.attempt.id, step: @attempt_builder.step.to_i, saved: true)
    else
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        # @attempt_builder.attempt.save!
        if @attempt_builder.completed_and_valid?
          redirect_to after_answer_path_for
        elsif @attempt_builder.answers_valid?
          redirect_to edit_attempt_flat_path(id: @attempt_builder.attempt.id, step: @attempt_builder.step.to_i + 1)
        else
          render :edit
        end
      else
        render :edit
      end
    end
  end

  def over; end

  private

  def find_client!
    @client = Client.find(params[:client_id])
  end

  def find_survey!
    @survey = @client.surveys.find(params[:survey_id])
  end

  def find_attempt!
    @attempt = params[:id].present? ? Attempt.find(params[:id]) : Attempt.new
  end

  def set_step!
    @step = params[:step]
    @percent = [(@step.to_f ),0].max / @survey.pages.to_f * 100
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

  def set_submit_text!
    @submit_text = @survey.pages == @step.to_i ? I18n.t('form.finish') : I18n.t('form.next')
  end
end

