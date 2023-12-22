class QuestionForm < BaseService
  AVAILABLE_QUESTIONS =
    [
      Questions::Checkbox,
      Questions::CheckboxShort,
      # Questions::Date,
      # Questions::Long,
      # Questions::Numeric,
      Questions::Radio,
      Questions::Select,
      Questions::Short,
      Questions::Information,
      Questions::MatrixHeader,
      Questions::MatrixRadio,
      Questions::MatrixRating,
    ]

  QUESTION_TYPES = AVAILABLE_QUESTIONS.inject({}) do |result, question|
    question_name = question.to_s.split("::").last
    result[question_name] = question.to_s
    result
  end

  attr_accessor :client, :survey, :question, :default_text, :placeholder,
    :type, :question_text, :question_text_1, :section, :position, :answer_options, :answer_presence,
    :answer_minimum_length, :answer_maximum_length, :page, :shuffle_options,
    :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to, :matrix_size,
    :answer_presence_on_question, :answer_presence_on_answers, :answer_uniqueness_on_section,
    :answer_answer_text_count_equals_to, :answer_presence_on_section_if_checked, :answer_checked_and_not_required_short

  delegate :valid?, :errors, :to => :question

  def initialize(params = {})
    from_question_to_attributes(params[:question]) if params[:question]
    super(params)
    @question ||= survey.questions.new
  end

  def save
    @question.new_record? ? create_question : update_question
  end

  private
  def create_question
    klass = nil
    if QUESTION_TYPES.values.include?(type)
      klass = type.constantize
    else
      errors.add(:type, :invalid)
      return false
    end

    @question = klass.create(to_question_params)
  end

  def update_question
    @question.update(to_question_params)
  end

  def to_question_params
    {
      :type => type,
      :survey => survey,
      :question_text  => question_text,
      :question_text_1  => question_text_1,
      :section => section,
      :page => page,
      :position => position,
      :default_text => default_text,
      :placeholder => placeholder,
      :answer_options => answer_options,
      :shuffle_options => shuffle_options,
      :matrix_size => matrix_size,
      :validation_rules => {
        :presence => answer_presence,
        :presence_on_question => answer_presence_on_question,
        :presence_on_answers => answer_presence_on_answers,
        :uniqueness_on_section => answer_uniqueness_on_section,
        :answer_text_count_equals_to => answer_answer_text_count_equals_to,
        :presence_on_section => answer_presence_on_section_if_checked,
        :check_and_not_required_short => answer_checked_and_not_required_short,
        :minimum  => answer_minimum_length,
        :maximum  => answer_maximum_length,
        :greater_than_or_equal_to => answer_greater_than_or_equal_to,
        :less_than_or_equal_to    => answer_less_than_or_equal_to
      }
    }
  end

  def from_question_to_attributes(question)
    self.type = question.type
    self.survey  = question.survey
    self.question_text   = question.question_text
    self.question_text_1   = question.question_text_1
    self.section = question.section
    self.page = question.page
    self.position = question.position
    self.default_text    = question.default_text
    self.placeholder     = question.placeholder
    self.answer_options  = question.answer_options
    self.shuffle_options = question.shuffle_options
    self.matrix_size  = question.matrix_size
    self.answer_presence = question.rules[:presence]
    self.answer_presence_on_question = question.rules[:presence_on_question]
    self.answer_presence_on_answers = question.rules[:presence_on_answers]
    self.answer_uniqueness_on_section = question.rules[:uniqueness_on_section]
    self.answer_answer_text_count_equals_to = question.rules[:answer_text_count_equals_to]
    self.answer_presence_on_section_if_checked = question.rules[:presence_on_section]
    self.answer_checked_and_not_required_short = question.rules[:check_and_not_required_short]
    self.answer_minimum_length = question.rules[:minimum]
    self.answer_maximum_length = question.rules[:maximum]
    self.answer_greater_than_or_equal_to = question.rules[:greater_than_or_equal_to]
    self.answer_less_than_or_equal_to    = question.rules[:less_than_or_equal_to]
  end
end

