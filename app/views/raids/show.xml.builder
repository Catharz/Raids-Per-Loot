xml.instruct!
xml.raid do
  xml.id @raid.id, type: 'integer'
  xml.tag! 'raid-date', @raid.raid_date, type: 'date'
  xml.tag! 'created-at', @raid.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @raid.updated_at.xmlschema, type: 'datetime'
  xml.tag! 'raid-type-id', @raid.raid_type_id, type: 'integer'
  if @raid.players.empty?
    xml.players type: 'array'
  else
    xml.players type: 'array' do
      @raid.players.collect { |player| xml << player.to_xml(skip_instruct: true) }
    end
  end
  if @raid.characters.empty?
    xml.characters type: 'array'
  else
    xml.characters type: 'array' do
      @raid.characters.collect { |character| xml << character.to_xml(skip_instruct: true) }
    end
  end
  if @raid.instances.empty?
    xml.instances type: 'array'
  else
    xml.instances type: 'array' do
      @raid.instances.collect { |instance| xml << instance.to_xml(skip_instruct: true) }
    end
  end
  if @raid.kills.empty?
    xml.kills type: 'array'
  else
    xml.kills type: 'array' do
      @raid.kills.collect { |kill| xml << kill.to_xml(skip_instruct: true) }
    end
  end
  if @raid.drops.empty?
    xml.drops type: 'array'
  else
    xml.drops type: 'array' do
      @raid.drops.collect { |drop| xml << drop.to_xml(skip_instruct: true) }
    end
  end
end