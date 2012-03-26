class DropValidator < ActiveModel::Validator
  def validate_player(record)
    unless Player.exists?(:name => record.player_name)
      record.errors[:base] << "A valid player must exist to be able to create drops for them"
    end
  end

  def validate_zone(record)
    unless Zone.exists?(:name => record.zone_name)
      record.errors[:base] << "A valid zone must exist to be able to create drops for it"
    end
  end

  def validate_instance(record)
    unless Instance.by_time(drop_time).exists?(zone_id => Zone.find(:name => record.zone_name.id))
      record.errors[:base] << "An instance must exist for the entered zone and drop time to be able to create drops for it"
    end
  end

  def validate_mob(record)
    unless Mob.by_zone_name(record.zone_name).exists?(:name => record.mob_name)
      record.errors[:base] << "A mob must exist for the entered zone to be able to create drops for it"
    end
  end

  def validate_item(record)
    unless Item.exists?(:name => record.item_name)
      record.errors[:base] << "A loot item must exist to be able to record it dropping"
    end
  end

  def validate(record)
    if record.assigned_to_player
      validate_player(record)
      validate_zone(record)
      validate_instance(record)
      validate_mob(record)
      validate_item(record)
    end
  end
end