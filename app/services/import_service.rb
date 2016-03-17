class ImportService

  attr_accessor :errors, :questions

  def initialize
    @errors = []
  end

  def clean_questions(questions)
    # question:nominal\nquestion:nominal\n
    questions = questions.split("\n").delete_if { |q| q.empty? }

    questions = questions.map do |question|
      # Get question and nominal
      tab = question.split(':')
      [tab[0], tab[1]]
    end

    @questions = questions
  end

end
