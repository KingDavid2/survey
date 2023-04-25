require 'csv'

class Survey < ApplicationRecord
  self.implicit_order_column = "created_at"

  extend FriendlyId
  friendly_id :name, use: :scoped, scope: [:client]

  belongs_to :client
  has_many  :attempts
  has_many :answers, through: :attempts

  has_many  :questions

  validates :name, presence: true

  has_rich_text :introduction
  has_rich_text :conclusion

  def sections
    questions.pluck(:section).uniq.count
  end

  def last_section_number
    questions.pluck(:section).sort.last || 1
  end

  def last_position_number
    questions.pluck(:position).sort.last || 0
  end

  # def self.csv_user_attributes=(attributes)
  #   @@csv_user_attributes = Array(attributes)
  # end

  # def self.csv_user_attributes
  #   @@csv_user_attributes || []
  # end

  def results_to_csv(filter)
    CSV.generate do |csv|
      header = []
      # header += Survey.csv_user_attributes
      questions.each do |question|
        header << ActionView::Base.full_sanitizer.sanitize(question.question_text_plain, :tags => [], :attributes => [])
      end
      header << "results updated at"
      csv << header
      attempts.where(SurveyResults.filter(filter, 'id')).each do |attempt|
        this_attempt = []

        # Survey.csv_user_attributes.each do |attribute|
        #   this_attempt << attempt.user.try(attribute)
        # end

        questions.each do |question|
          answer = attempt.answers.detect{|a| a.question_id == question.id }.try(:answer_text)
          this_attempt << answer
        end

        this_attempt << attempt.updated_at
        csv << this_attempt
      end
    end
  end
end
