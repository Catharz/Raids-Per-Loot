json.drop do
  json.extract! @drop, :character_id, :chat, :created_at, :drop_time, :id, :instance_id, :item_id, :log_line,
                :loot_method, :loot_type_id, :mob_id, :updated_at, :zone_id, :loot_method_name, :invalid_reason,
                :character_name, :character_archetype_name, :loot_type_name, :item_name, :mob_name, :zone_name
end