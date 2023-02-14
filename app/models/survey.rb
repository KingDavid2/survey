class Survey < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many  :questions

  validates :name, presence: true
end
