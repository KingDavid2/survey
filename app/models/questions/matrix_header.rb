module Questions
  class MatrixHeader < Information
    def columns
      answer_options.split(Global.answers_delimiter)
    end

    def not_dot?
      question_text != '.'
    end
  end
end
