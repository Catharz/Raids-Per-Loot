class DropValidator < ActiveModel::Validator
  def validate_player(record)
    record.errors[:base] << "A valid player must exist to be able to create drops for them" unless Player.exists?(:name => record.player_name)
  end

  def validate_zone(record)
    record.errors[:base] << "A valid zone must exist to be able to create drops for it" unless Zone.exists?(:name => record.zone_name)
  end

  def validate(record)
    if record.assigned_to_player
      validate_player(record)
      validate_zone(record)
      record.errors[:base] << "An instance must exist for the entered zone and drop time to be able to create drops for it" unless Instance.find_by_zone_and_time(record.zone_name, record.drop_time)
      record.errors[:base] << "A mob must exist for the entered zone to be able to create drops for it" unless Mob.find_by_zone_and_mob_name(record.zone_name, record.mob_name)
      record.errors[:base] << "A loot item must exist to be able to record it dropping" unless Item.exists?(:name => record.item_name)
    end
  end
end