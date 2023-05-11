class QuestionTextSplit < BaseService
  attr_reader :params
  attr_accessor :questions

  def initialize(params = {})
    @params = params
    @questions = new_questions
  end

  # def question_text_split
  #   input_string = @params[:question_text]
  #   doc = Nokogiri::HTML.fragment(input_string)
  #   div_contents = doc.at_css('div').inner_html.split("<br>")
  #   divs = div_contents.map { |content| "<div>#{content.strip}</div>" }
  #   output_string = divs.join
  # end

  def question_text_split
    input_string = @params[:question_text]
    doc = Nokogiri::HTML.fragment(input_string)
    doc.css('div').inner_html.split('<br>').map(&:strip)
  end

  def new_questions
    position = @params[:position].to_i - 1
    question_text_split.map do |question_text|
      temp = @params.dup
      position += 1
      temp[:position] = position
      temp[:question_text] = "<div>#{question_text.strip}</div>"
      temp
    end
  end
end
