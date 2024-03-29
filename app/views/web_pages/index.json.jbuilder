json.array!(@web_pages) do |web_page|
  json.extract! web_page, :id, :url, :capture_image_path, :layout_pattern_id, :note
  json.url web_page_url(web_page, format: :json)
end
