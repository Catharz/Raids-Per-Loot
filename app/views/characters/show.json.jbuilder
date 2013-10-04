json.character do
  json.extract! @character, :adornment_rate, :adornments_count, :archetype_id, :armour_count, :armour_rate,
                :attuned_rate, :char_type, :confirmed_date, :confirmed_rating, :created_at, :dislodger_rate,
                :dislodgers_count, :id, :instances_count, :jewellery_count, :jewellery_rate, :mount_rate,
                :mounts_count, :name, :player_id, :raids_count, :updated_at, :weapon_rate, :weapons_count,
                :player_name, :player_raids_count, :player_active, :player_switches_count, :player_switch_rate
end