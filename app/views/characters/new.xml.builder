xml.instruct!
xml.character do
  xml.id type: 'integer', :nil => true
  xml.name :nil => true
  xml.tag! 'player-id', type: 'integer', :nil => true
  xml.tag! 'archetype-id', type: 'integer', :nil => true
  xml.tag! 'created-at', type: 'datetime', :nil => true
  xml.tag! 'updated-at', type: 'datetime', :nil => true
  xml.tag! 'char-type', :nil => true
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
  xml.tag! 'confirmed-rating', :nil => true
  xml.tag! 'confirmed-date', type: 'date', :nil => true
  xml.tag! 'player-name', :nil => true
end