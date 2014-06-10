json.player do
  json.extract! @player, :active, :adornment_rate, :adornments_count, :armour_count, :armour_rate, :attuned_rate, :created_at,
    :current_main, :current_raid_alternate, :dislodger_rate, :dislodgers_count, :first_raid_date, :id, :instances_count,
    :jewellery_count, :jewellery_rate, :last_raid_date, :mount_rate, :mounts_count, :name, :raids_count, :rank_id, :rank_name,
    :switch_rate, :switches_count, :updated_at, :weapon_rate, :weapons_count
end
