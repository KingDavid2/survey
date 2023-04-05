class Question < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :survey, :inverse_of => :questions
  has_many   :answers

  default_scope { order(:position) }
  scope :by_section, ->(section) { where('section = ?', section) }

  validates :survey, :question_text, :section, :position, :presence => true
  validate :type_can_change
  serialize :validation_rules
  has_rich_text :question_text

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Question.model_name
      end
    end

    super
  end

  def rules
    validation_rules.symbolize_keys || {}
  end

  def validation_rules=(val)
    super(val.stringify_keys)
  end

  # answer will delegate its validation to question, and question
  # will inturn add validations on answer on the fly!
  def validate_answer(answer)
    if rules[:presence] == "1"
      answer.validates_presence_of :answer_text
    end

    if rules[:minimum].present? || rules[:maximum].present?
      min_max = { minimum: rules[:minimum].to_i }
      min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

      answer.validates_length_of :answer_text, min_max
    end

    if rules[:presence_on_question].present? && rules[:presence_on_answers].present?
      needed_answers = rules[:presence_on_answers].split(Global.answers_delimiter)
      question = answer.attempt.questions.find_by_position(rules[:presence_on_question])
      # answers = answer.attempt.answers.where(answer_text: needed_answers, question_id: question.id)

      answers = answer.attempt.answers.pluck(:question_id, :answer_text).filter do |a|
        current_answers = a[1].to_s.split(Global.answers_delimiter)
        a[0]==question.id && needed_answers.intersection(current_answers).any?
      end

      if answers.present?
        answer.validates_presence_of :answer_text
      else
        answer.answer_text = ''
      end
    end

    if rules[:uniqueness_on_section].present?
      # get questions in section
      questions = answer.attempt.questions.where(section: rules[:uniqueness_on_section])

      # get answers in section
      answers = answer.attempt.answers.filter { | a | questions.ids.include? a.question_id }
      
      # count uniq
      count_answers = answers.pluck(:answer_text).count(answer.answer_text)
      if count_answers > 1
        answer.errors.add(:answer_text, :taken)
      end
    end
  end

  def filter_duplicates_by_my_attribute
    groups = answers.group_by(&:answer_text)
    groups.select { |_, records| records.size == 1 }.values.flatten
  end

  def type_can_change
    if type_changed? && answers.any?
      errors.add(:type, "cannot change after answers have been added")
    end
  end

  def partial_name
    type.to_s.split("::").last.underscore
  end

  def question_text_with_section
    section.to_s + '. ' + question_text.body.html_safe
  end

  def answers_array
    answer_options.split(Global.answers_delimiter)
  end

  def question_text_plain
    question_text.body.to_plain_text.squish
  end
end
