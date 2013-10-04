json.character do
  json.extract! @character, :adornment_rate, :adornments_count, :archetype_id, :armour_count, :armour_rate,
                :attuned_rate, :char_type, :confirmed_date, :confirmed_rating, :created_at, :dislodger_rate,
                :dislodgers_count, :id, :instances_count, :jewellery_count, :jewellery_rate, :mount_rate,
                :mounts_count, :name, :player_id, :raids_count, :updated_at, :weapon_rate, :weapons_count,
                :archetype_name, :main_character, :archetype_root, :player_name, :first_raid_date, :last_raid_date,
                :armour_rate, :jewellery_rate, :weapon_rate
end