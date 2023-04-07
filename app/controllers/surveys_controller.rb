  class SurveysController < ApplicationController
    before_action :authenticate_user!

    def index
      @surveys = Survey.all
    end

    def new
      @survey = Survey.new
    end

    def create
      @survey = Survey.new(survey_params)

      if @survey.save
        respond_to do |format|
          format.html { redirect_to surveys_path }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.js
        end
      end
    end

    def edit
      @survey = Survey.find(params[:id])
    end

    def update
      @survey = Survey.find(params[:id])
      if @survey.update(survey_params)
        respond_to do |format|
          format.html { redirect_to surveys_path }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.js
        end
      end
    end

    def destroy
      @survey = Survey.find(params[:id])
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract(filter_params)

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
        format.csv { send_data(@survey.results_to_csv(filter_params)) }
      end
    end

    def toggle_active
      @survey = Survey.find(params[:id])
      @survey.update(active: !@survey.active)
      redirect_to surveys_path
    end

    private

    def survey_params
      params.require(:survey).permit(:name, :introduction, :conclusion, :active, :client_id)
    end

    def filter_params
      params[:filter].permit({ question_ids: [], options: []})
    end
  end
