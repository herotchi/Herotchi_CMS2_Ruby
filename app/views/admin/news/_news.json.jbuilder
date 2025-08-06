json.extract! news, :id, :title, :link_flg, :url, :overview, :release_date, :release_flg, :created_at, :updated_at
json.url news_url(news, format: :json)
