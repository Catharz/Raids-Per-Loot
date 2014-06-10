json.array! @zones do |zone|
  json.zone do
    json.extract! zone, :created_at, :difficulty_id, :id, :name, :updated_at
  end
end
