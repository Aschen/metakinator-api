json.array!(@entities) do |entity|
  json.extract! entity, :id, :name
  json.url entity_url(entity, format: :json)
end
