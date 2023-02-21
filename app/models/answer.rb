class Answer < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :question
  belongs_to :attempt, inverse_of: :answers

  validates :question, :attempt, presence: true
end
