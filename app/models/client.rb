class Client < ApplicationRecord
  self.implicit_order_column = "created_at"

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :surveys
  has_one_attached :nav_logo
end
