json.extract! product, :id, :first_category_id, :second_category_id, :name, :image, :detail, :release_flg, :created_at, :updated_at
json.url product_url(product, format: :json)
