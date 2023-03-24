class Answer < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :question
  belongs_to :attempt, inverse_of: :answers

  validates :question, :attempt, presence: true
  validate  :verify_answer_text

  # validates_uniqueness_of :answer_text, scope: [:attempt, :section], if: -> { question.rules[:uniqueness_on_section] == question.section.to_s }

  def verify_answer_text
    return false unless question.present?
    question.validate_answer(self)
  end

  def partial_name
    question.type.to_s.split("::").last.underscore
  end

  def self.all_answer_texts(question, survey)
    joins(attempt: :survey).where(question: question, survey: {id: survey.id} ).pluck(:answer_text).join(' ')
  end

  def self.group_by_question_and_survey(question, survey)
    hash = joins(attempt: :survey).where(question: question, survey: {id: survey.id} ).group(:answer_text).count
    fill_missing_keys(hash, question)
  end

  def self.fill_missing_keys(hash, question)
    new_hash = {}
    question.answers_array.each do |key|
      new_hash[key] = hash[key] || 0
    end
    new_hash
  end
end
