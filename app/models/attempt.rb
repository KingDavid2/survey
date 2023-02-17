class Attempt < ApplicationRecord
  belongs_to :survey
  has_many   :answers, inverse_of: :attempt, autosave: true
end
