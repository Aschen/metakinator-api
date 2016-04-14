class DaneelService

  attr_accessor :errors

  def initialize
    @errors = []
  end

  # asked_questions: id of already asked questions
  #
  def get_best_question(asked_questions)
    questions = Question.all - asked_questions

    results = calc_questions_score(questions)

    results.sort_by! { |q| q[:score] }.reverse!

    return results.first[:question]
  end

  def get_first_question
    results = calc_questions_score(Question.all)

    range = results.size < 10 ? results.size : 10
    return results.first(range)[(rand() * range).to_i][:question]
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
    return (1..5).inject(1) do |score, i|
      score *= question.answers.where(answer: i)
                               .count + 1 # Ensure we dont * by 0
    end

    # Calculate number of entities matching each answer
    answer_yes = question.answers.where(answer: 1).count + 1
    answer_probably_yes = question.answers.where(answer: 2).count + 1
    answer_dont_know = question.answers.where(answer: 3).count + 1
    answer_probably_no = question.answers.where(answer: 4).count + 1
    answer_no = question.answers.where(answer: 5).count + 1

    # Calculate score for question
    score = answer_yes * answer_probably_yes * answer_dont_know * answer_probably_no * answer_no

    return score
  end

end
