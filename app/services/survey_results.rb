class SurveyResults < BaseService
  attr_accessor :survey

  # extracts question along with results
  # each entry will have the following:
  # 1. question type and question id
  # 2. question text
  # 3. if aggregatable, return each option with value
  # 4. else return an array of all the answers given
  def extract(filter_params = {}, by_section = false)
    results = @survey.questions.collect do |question|
      answers = question.answers.completed_attempts.where(*filter(filter_params)).pluck(:answer_text)
      results =
        case question
        when Questions::Select, Questions::Radio, Questions::Checkbox,
          Questions::MatrixRating, Questions::MatrixRating
          answers = answers.map do |text|
            text.to_s.split(Global.answers_delimiter)
          end.flatten

          count_hash = Hash.new(0)
          question.options.map{|o| count_hash[o] = 0 }

          answers.inject(count_hash) { |total, e| total[e] += 1; total }
        when Questions::Short, Questions::Date,
          Questions::Long, Questions::Numeric
          answers
        end

      average = set_result_average(results)

      QuestionResult.new(question: question, results: results, average: average)
    end

    return group_by_section(results) if by_section

    results
  end

  def filter(filter_params, column = 'attempt_id')
    @filter_result ||= begin
      return ["0=0"] unless Array(filter_params[:question_ids]).compact.count == Array(filter_params[:options]).compact.count
      return ["0=0"] unless %w(id attempt_id).include?(column)
      return ["0=0"] if Array(filter_params[:question_ids]).compact.count == 0

      collected_filters = {}
      Array(filter_params[:question_ids]).each_with_index do |question_id, i|
        collected_filters[question_id] ||= []
        collected_filters[question_id] << filter_params[:options][i]
      end

      attempt_ids = nil

      collected_filters.each do |question_id, options|
        these_matches = Answer.where("question_id = ? and answer_text in (?)", question_id, options).pluck(:attempt_id)
        if attempt_ids.nil?
          attempt_ids = these_matches
        else
          attempt_ids = attempt_ids & these_matches
        end
      end

      ["#{column} in (?)", attempt_ids]
    end
  end

  def group_by_section(results)
    results.group_by{ |result| result.question.section }
  end

  def self.filter(filter_params, column)
    self.new.filter(filter_params, column)
  end

  def set_result_average(result)
    return 0 unless all_integer_answers?(result)

    result.map { |k, v| k.to_i * v }.reduce(:+) / result.values.sum.to_f
  end

  def all_integer_answers?(answers)
    return false unless answers.keys.any?

    answers.keys.all? { |answer| answer.to_i.to_s == answer }
  rescue
    false
  end
end

