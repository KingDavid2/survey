class ResultsController < ApplicationController
  before_action :find_client!
  before_action :find_surveys!
  before_action :find_survey!, only: :show


  def index
  end

  def show
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
end
