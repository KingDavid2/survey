class Question < ApplicationRecord
  belongs_to :survey, inverse_of: :questions
  has_many   :answers

  validates :survey, :question_text, presence: true
end
