class DaneelService

  attr_accessor :errors

  def initialize(entity_class)
    @errors = []
    @entity_class = entity_class
  end

  # asked_questions: id of already asked questions
  #
  def get_best_question(asked_questions)
    questions = Question.where(entity_class: @entity_class) - asked_questions

    results = calc_questions_score(questions)

    results.sort_by! { |q| q[:score] }.reverse!

    if results.any?
      return results.first[:question]
    else
      return nil
    end
  end

  def get_first_question
    results = calc_questions_score(Question.where(entity_class: @entity_class))

    range = results.size < 10 ? results.size : 10
    return results.first(range)[(Random.rand() * range).to_i][:question]
  end

  private #=====================================================================

  def calc_questions_score(questions)
    results = questions.map do |question|
      { score: calc_question_score(question), question: question}
    end

    results.sort_by! { |q| q[:score] }.reverse!

    return results
  end

  def calc_question_score(question)
    (1..5).inject(1) do |score, i|
      score *= question.answers.where(answer: i).count + 1 # Ensure we dont * by 0
    end
  end

end
