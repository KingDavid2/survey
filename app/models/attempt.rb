class Attempt < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :survey
  has_many :answers, inverse_of: :attempt, autosave: true
end
