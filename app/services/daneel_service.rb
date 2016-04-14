class DaneelService

  attr_accessor :errors

  def initialize
    @errors = []
  end

  def get_best_question(questions, newgame)

    results = questions.map do |question|
      { score: calc_question_score(question), question: question}
    end

    results.sort_by! { |q| q[:score] }.reverse!

    if newgame
      # Select 10 best questions and get a random one
      range = results.size < 10 ? results.size : 10
      return results.first(range)[(rand() * range).to_i][:question]
    else
      return results.first[:question]
    end
  end

  private #=====================================================================

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
