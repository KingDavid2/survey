class AttemptBuilder < BaseService
  attr_accessor :user, :survey, :questions, :answers, :params, :attempt_id, :attempt, :step, :action

  def initialize(params = {})
    super(params)
    self.step ||= 0
    build_attempt
  end

  def to_model
    @attempt
  end

  def save!(options = {})
    params.each do |question_id, answer_attributes|
      answer = @attempt.answers.find { |a| a.question_id.to_s == question_id.to_s }
      next unless answer

      text = answer_attributes[:answer_text]

      # in case of checkboxes, values are submitted as an array of
      # strings. we will store answers as one big string separated
      # by delimiter.
      text = text.values if text.is_a?(ActionController::Parameters)

      if text.is_a?(Array)
        answer.answer_text = strip_checkbox_answers(text).join(Global.answers_delimiter)
      elsif answer.question.class == Questions::CheckboxShort && answer.answer_text == '0'
        answer.answer_text = nil
      else
        answer.answer_text = text
      end
      answer.question.validate_answer(answer)

      # answer.save!
    end
    @attempt.save!
  end

  def save(options = {})
    save!(options)
  rescue ActiveRecord::ActiveRecordError => e
    # repopulate answers here in case of failure as they are not getting updated
    @answers = @survey.questions.where(section: @step).collect do |question|
      @attempt.answers.find { |a| a.question_id == question.id }
    end
    false
  end

  # def update_attempt(attempt_id, step)
  #   @attempt = Attempt.find(attempt_id)
  #     @answers = @survey.questions.where(section: step).collect do |question|
  #     @attempt.answers.create(question_id: question.id)
  #   end
  # end

  def answered_questions
    @attempt.answers.pluck(:question_id)
  end
  
  private

  def build_attempt
    # if attempt_id.present?
    #   @attempt = Attempt.find(attempt_id)
    #   @answers = @attempt.answers
    #   # @user = @attempt.user
    #   # @survey = @attempt.survey
    #   @questions = @survey.questions.where(section: step)
    # else
    #   @attempt = Attempt.new(survey: survey)
    # end
    @attempt.survey = self.survey
    @answers = @survey.questions.where(section: @step).collect do |question|
      if answered_questions.include? question.id
        @attempt.answers.find_by(question_id: question.id)
      else
        @attempt.answers.new(question_id: question.id)
      end
    end
  end

  def strip_checkbox_answers(answers)
    answers.reject(&:blank?).reject { |t| t == "0" }
  end
end
