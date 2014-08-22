json.array!(@reviews) do |review|
  json.extract! review, :id, :reviewText, :mark, :user_id, :service_id, :cto_id
  json.url review_url(review, format: :json)
end
