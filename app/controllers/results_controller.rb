class ResultsController < ApplicationController
  before_action :find_client!
  before_action :find_surveys!
  before_action :find_survey!, only: :show

  def index
  end

  def show
    params[:filter] ||= {}
    @survey_results = SurveyResults.new(survey: @survey).extract(filter_params, true)

    respond_to do |format|
      format.html
      format.csv { send_data(@survey.results_to_csv(filter_params)) }
    end
  end

  private

  def find_client!
    @client = Client.find(params[:client_id])
  end

  def find_surveys!
    @surveys = @client.surveys
  end

  def find_survey!
    @survey = @client.surveys.find params[:survey_id]
  end

  def survey_params
    params.require(:survey).permit(:name, :introduction, :conclusion, :active)
  end

  def filter_params
    params[:filter].permit({ question_ids: [], options: []})
  end
end
