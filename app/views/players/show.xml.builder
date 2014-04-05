xml.instruct!
xml.player do
  xml.active @player.active, type: 'boolean'
  xml.tag! 'adornment-rate', @player.adornment_rate, type: 'float'
  xml.tag! 'adornments-count', @player.adornments_count, type: 'integer'
  xml.tag! 'armour-count', @player.armour_count, type: 'integer'
  xml.tag! 'armour-rate', @player.armour_rate, type: 'float'
  xml.tag! 'attuned-rate', @player.attuned_rate, type: 'float'
  xml.tag! 'created-at', @player.created_at.xmlschema, type: 'datetime'
  xml.tag! 'dislodger-rate', @player.dislodger_rate, type: 'float'
  xml.tag! 'dislodgers-count', @player.dislodgers_count, type: 'integer'
  xml.id @player.id, type: 'integer'
  xml.tag! 'instances-count', @player.instances_count, type: 'integer'
  xml.tag! 'jewellery-count', @player.jewellery_count, type: 'integer'
  xml.tag! 'jewellery-rate', @player.jewellery_rate, type: 'float'
  xml.tag! 'mount-rate', @player.mount_rate, type: 'float'
  xml.tag! 'mounts-count', @player.mounts_count, type: 'integer'
  xml.name @player.name
  xml.tag! 'raids-count', @player.raids_count, type: 'integer'
  xml.tag! 'rank-id', @player.rank_id
  xml.tag! 'switch-rate', @player.switch_rate, type: 'float'
  xml.tag! 'switches-count', @player.switches_count, type: 'integer'
  xml.tag! 'updated-at', @player.updated_at.xmlschema, type: 'datetime'
  xml.tag! 'weapon-rate', @player.weapon_rate, type: 'float'
  xml.tag! 'weapons-count', @player.weapons_count, type: 'integer'
end
