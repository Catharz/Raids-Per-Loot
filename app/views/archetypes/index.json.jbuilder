json.array! @archetypes do |archetype|
  json.archetype do
    json.extract! archetype, :created_at, :id, :name, :parent_id, :updated_at, :parent_name, :root_name
  end
end