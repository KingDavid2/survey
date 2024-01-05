class Document < ApplicationRecord
  validates :name, presence: true
  belongs_to :client

  has_one_attached :file
end
