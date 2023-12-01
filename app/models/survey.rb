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

  def pages
    questions.pluck(:page).uniq.count
  end

  def last_section_number
    questions.by_page(questions.last(2).first.page).pluck(:section).sort.last || 1
  end

  def last_page_number
    questions.where.not(page: nil).pluck(:page).sort.last || 1
  end

  def last_position_number
    questions.where.not(position: nil).pluck(:position).sort.last || 0
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
      attempts.completed.where(SurveyResults.filter(filter, 'id')).each do |attempt|
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

  def duplicate
    ActiveRecord::Base.transaction do
      new_survey = self.dup
      self.questions.each do |question|

        new_question = question.dup
        new_question.question_text = question.question_text.dup
        new_question.question_text_1 = question.question_text_1.dup

        new_survey.questions << new_question
      end
      new_survey.save
    end
  end
end
