class Attempt < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :survey
  has_many :answers, inverse_of: :attempt, autosave: true

  delegate :questions, to: :survey

  after_save :is_completed?

  def is_completed?
    if questions.count == answers.count
      self.completed = true
    else
      false
    end
  end
end
