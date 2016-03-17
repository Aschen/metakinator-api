class Answer < ActiveRecord::Base

  belongs_to :question

  enum answer: {
    yes: 1,
    probably_yes: 2,
    dont_know: 3,
    probably_no: 4,
    no: 5
  }

end
