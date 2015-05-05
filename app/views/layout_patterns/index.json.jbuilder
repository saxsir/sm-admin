json.array!(@layout_patterns) do |layout_pattern|
  json.extract! layout_pattern, :id, :name, :note
  json.url layout_pattern_url(layout_pattern, format: :json)
end
