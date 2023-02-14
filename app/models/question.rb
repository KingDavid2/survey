class Question < ApplicationRecord
  belongs_to :survey, inverse_of: :questions

  validates :survey, :question_text, presence: true
end
