json.array!(@entities) do |entity|

  json.extract! entity, :id, :name, :klass

  json.answers entity.answers.map { |a| a.id }

end
