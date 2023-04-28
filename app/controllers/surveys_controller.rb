  class SurveysController < ApplicationController
    include Pundit
    before_action :authenticate_user!
    after_action :verify_authorized
    before_action :find_client!, except: [:index, :new, :create]
    before_action :find_survey!, except: [:index, :new, :create]

    def index
      @surveys = Survey.all
      authorize(@surveys)
    end

    def new
      @survey = Survey.new
      authorize(@survey)
    end

    def create
      @survey = Survey.new(survey_params)
      authorize(@survey)

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
    end

    def update
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
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
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
      @survey.update(active: !@survey.active)
      redirect_to surveys_path
    end

    def find_client!
      @client = Client.find(params[:client_id])
    end

    def find_survey!
      @survey = @client.surveys.find(params[:id])
      authorize(@survey)
    end

    private

    def survey_params
      params.require(:survey).permit(:name, :introduction, :conclusion, :active, :client_id)
    end

    def filter_params
      params[:filter].permit({ question_ids: [], options: []})
    end
  end
