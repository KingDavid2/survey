class Answer < ApplicationRecord
  belongs_to :attempt
  belongs_to :attempt, inverse_of: :answers

  validates :question, :attempt, presence: true
end
