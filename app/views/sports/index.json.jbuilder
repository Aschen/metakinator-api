json.array!(@sports) do |sport|

  json.id sport.id
  json.name sport.name

  json.questions(sport.answers.preload(:question)) do |answer|
    json.question answer.question.title
    json.answer answer.answer
  end

end
