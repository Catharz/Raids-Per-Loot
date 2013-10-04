xml.instruct!
xml.tag! 'drops', type: 'array' do
  @drops.each do |drop|
    xml.drop do
      xml.id drop.id, type: 'integer'
      xml.tag! 'drop-time', drop.drop_time.xmlschema, type: 'datetime'
      xml.tag! 'created-at', drop.created_at.xmlschema, type: 'datetime'
      xml.tag! 'updated-at', drop.updated_at.xmlschema, type: 'datetime'
      xml.tag! 'zone-id', drop.zone_id, type: 'integer'
      xml.tag! 'mob-id', drop.mob_id, type: 'integer'
      xml.tag! 'character-id', drop.character_id, type: 'integer'
      xml.tag! 'item-id', drop.item_id, type: 'integer'
      xml.tag! 'loot-type-id', drop.loot_type_id, type: 'integer'
      xml.tag! 'instance-id', drop.instance_id, type: 'integer'
      xml.tag! 'loot-method', drop.loot_method
      xml.tag! 'log-line', drop.log_line
      xml.chat drop.chat
    end
  end
end
