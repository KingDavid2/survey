module Questions
  class MatrixRating < Radio
    def not_dot?
      question_text != '.'
    end
  end
end
