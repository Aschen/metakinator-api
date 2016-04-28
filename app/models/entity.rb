class Entity < ActiveRecord::Base

  has_many :answers, dependent: :destroy

  def questions
    Question.all
  end

  def add_answer(question, answer)
    question = question.id if question.is_a? Question
    answer = answer.to_i if answer.is_a? String
    answer = self.answers.new(question_id: question, answer: answer)

    if answer.save
      answer
    else
      nil
    end
  end
end
