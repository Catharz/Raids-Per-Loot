json.array! @character_instances do |character_instance|
  json.character_instance do
    json.extract! character_instance, :id, :character_id, :instance_id
  end
end
