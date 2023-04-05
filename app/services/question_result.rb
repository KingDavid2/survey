class QuestionResult < BaseService
  include ActiveModel::Serialization

  attr_accessor :question, :results, :average

  def active_model_serializer
    QuestionResultSerializer
  end
end
