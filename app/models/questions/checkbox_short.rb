module Questions
  class CheckboxShort < Short
    def validate_answer(answer)
      super(answer)

      if rules[:presence_on_section] == "1"
        # get questions in section
        questions = answer.attempt.questions.where(section: answer.question.section)

        # get answers in section
        answers = answer.attempt.answers.filter { | a | questions.ids.include? a.question_id }

        if answers.pluck(:answer_text).compact.empty? || answer.answer_text == ''
          answer.validates_presence_of :answer_text
        end
      end
    end
  end
end
