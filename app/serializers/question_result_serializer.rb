class QuestionResultSerializer < ActiveModel::Serializer
  attributes :question_type, :question_text, :results

  def question_type
    object.question.type
  end

  def question_text
    object.question.question_text
  end
end
