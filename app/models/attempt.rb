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
end

