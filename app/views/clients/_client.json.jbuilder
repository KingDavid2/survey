json.extract! client, :id, :name, :slug, :created_at, :updated_at
json.url client_url(client, format: :json)
