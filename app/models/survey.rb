class Survey < ApplicationRecord
  self.implicit_order_column = "created_at"

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :client
  has_many  :attempts
  has_many  :questions

  validates :name, presence: true

  has_rich_text :introduction
  has_rich_text :conclusion

  def sections
    questions.pluck(:section).uniq.count
  end

  def last_section_number
    questions.pluck(:section).sort.last
  end

  def last_position_number
    questions.pluck(:position).sort.last
  end
end
