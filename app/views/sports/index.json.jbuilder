json.array!(@sports) do |sport|
  json.extract! sport, :id, :name
  json.url sport_url(sport, format: :json)
end
