json.mob do
  json.extract! @mob, :alias, :created_at, :difficulty_id, :id, :name, :strategy, :updated_at, :zone_id
end