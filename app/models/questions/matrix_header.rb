module Questions
  class MatrixHeader < Information
    def columns
      answer_options.split(Global.answers_delimiter)
    end
  end
end
