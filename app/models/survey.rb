class Survey < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :client
  has_many  :attempts
  has_many  :questions

  validates :name, presence: true
end
