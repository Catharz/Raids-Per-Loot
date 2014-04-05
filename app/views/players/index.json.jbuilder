json.array! @players do |player|
  json.player do
    json.extract! player, :active, :adornment_rate, :adornments_count, :armour_count, :armour_rate, :attuned_rate, :created_at,
      :dislodger_rate, :dislodgers_count, :id, :instances_count, :jewellery_count, :jewellery_rate, :mount_rate, :mounts_count,
      :name, :raids_count, :rank_id, :switch_rate, :switches_count, :updated_at, :weapon_rate, :weapons_count
  end
end
