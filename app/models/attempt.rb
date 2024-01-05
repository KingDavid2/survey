class Attempt < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :survey
  has_many :answers, inverse_of: :attempt, autosave: true
  scope :completed, -> { where(completed: true) }

  delegate :questions, to: :survey

  after_save :is_completed?

  def self.completed_count
    completed.count
  end

  def is_completed?
    if questions.count == answers.count
      self.update_column(:completed, true)
      true
    else
      false
    end
  end

  # TERMS CHECKED FLOW

  def has_any_term_question?
    term_questions.any?
  end

  def term_questions
    questions_with_accept_privacy = questions.select do |question|
      validation_rules = question.validation_rules
      validation_rules["accept_privacy"] == "1"
    end
  end

  def term_question_ids
    term_questions.pluck(:id)
  end

  def terms_accepted?
    return true unless has_any_term_question?

    term_questions.all? do |question|
      answer = answers.find_by(question_id: question.id)
      question.validation_rules["accept_privacy_on_selection"] == answer.answer_text
    end
  end

  def reset_answers_if_not_accept_privacy
    return if terms_accepted?

    reset_answers(term_question_ids)
  end

  def reset_answers(except_question_ids = [])
    self.answers.where.not(question_id: except_question_ids).destroy_all
  end
end
