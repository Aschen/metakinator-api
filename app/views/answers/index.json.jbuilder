json.array!(@answers) do |answer|
  json.extract! answer, :id, :sport_id, :question_id, :answer
  json.url answer_url(answer, format: :json)
end
