xml.instruct!
xml.drop do
  xml.id @drop.id, type: 'integer'
  xml.tag! 'drop-time', @drop.drop_time.xmlschema, type: 'datetime'
  xml.tag! 'created-at', @drop.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @drop.updated_at.xmlschema, type: 'datetime'
  xml.tag! 'zone-id', @drop.zone_id, type: 'integer'
  xml.tag! 'mob-id', @drop.mob_id, type: 'integer'
  xml.tag! 'character-id', @drop.character_id, type: 'integer'
  xml.tag! 'item-id', @drop.item_id, type: 'integer'
  xml.tag! 'loot-type-id', @drop.loot_type_id, type: 'integer'
  xml.tag! 'instance-id', @drop.instance_id, type: 'integer'
  xml.tag! 'loot-method', @drop.loot_method
  xml.tag! 'log-line', @drop.log_line
  xml.chat @drop.chat
  xml.tag! 'loot-method-name', @drop.loot_method_name
  xml.tag! 'invalid-reason', @drop.invalid_reason
  xml.tag! 'character-name', @drop.character_name
  xml.tag! 'character-archetype-name', @drop.character_archetype_name
  xml.tag! 'loot-type-name', @drop.loot_type_name
  xml.tag! 'item-name', @drop.item_name
  xml.tag! 'mob-name', @drop.mob_name
  xml.tag! 'zone-name', @drop.zone_name
end