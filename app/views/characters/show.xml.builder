xml.instruct!
xml.character do
  xml.id @character.id, type: 'integer'
  xml.name @character.name
  xml.tag! 'player-id', @character.player_id, type: 'integer'
  xml.tag! 'archetype-id', @character.archetype_id, type: 'integer'
  xml.tag! 'created-at', @character.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @character.updated_at.xmlschema, type: 'datetime'
  xml.tag! 'char-type', @character.char_type
  xml.tag! 'instances-count', @character.instances_count, type: 'integer'
  xml.tag! 'raids-count', @character.raids_count, type: 'integer'
  xml.tag! 'armour-rate', @character.armour_rate, type: 'float'
  xml.tag! 'jewellery-rate', @character.jewellery_rate, type: 'float'
  xml.tag! 'weapon-rate', @character.weapon_rate, type: 'float'
  xml.tag! 'armour-count', @character.armour_count, type: 'integer'
  xml.tag! 'jewellery-count', @character.jewellery_count, type: 'integer'
  xml.tag! 'weapons-count', @character.weapons_count, type: 'integer'
  xml.tag! 'adornments-count', @character.adornments_count, type: 'integer'
  xml.tag! 'dislodgers-count', @character.dislodgers_count, type: 'integer'
  xml.tag! 'mounts-count', @character.mounts_count, type: 'integer'
  xml.tag! 'adornment-rate', @character.adornment_rate, type: 'float'
  xml.tag! 'dislodger-rate', @character.dislodger_rate, type: 'float'
  xml.tag! 'mount-rate', @character.mount_rate, type: 'float'
  xml.tag! 'attuned-rate', @character.attuned_rate, type: 'float'
  if @character.confirmed_rating.nil?
    xml.tag! 'confirmed-rating', :nil => true
  else
    xml.tag! 'confirmed-rating', @character.confirmed_rating
  end
  if @character.confirmed_date.nil?
    xml.tag! 'confirmed-date', type: 'date', :nil => true
  else
    xml.tag! 'confirmed-date', @character.confirmed_date, type: 'date'
  end
  if @character.instances.empty?
    xml.tag! 'instances', type: 'array'
  else
    xml.tag! 'instances', @character.instances, type: 'array'
  end
  if @character.drops.empty?
    xml.tag! 'drops', type: 'array'
  else
    xml.tag! 'drops', @character.drops, type: 'array'
  end
end