json.array!(@sports) do |sport|

  json.extract! sport, :id, :name

  json.answers sport.answers.map { |a| a.id }

end
