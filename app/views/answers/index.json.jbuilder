json.array!(@answers) do |answer|
  json.extract! answer, :id, :entity_id, :question_id, :answer
end
