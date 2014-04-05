xml.instruct!
xml.tag! 'raid-types', type: 'array' do
  @raid_types.each do |raid_type|
    xml.tag! 'raid-type' do
      xml.id(raid_type.id, type: 'integer')
      xml.name(raid_type.name)
      xml.tag! 'raid-counted', raid_type.raid_counted, type: 'boolean'
      xml.tag! 'raid-points', raid_type.raid_points, type: 'float'
      xml.tag! 'loot-counted', raid_type.loot_counted, type: 'boolean'
      xml.tag! 'loot-cost', raid_type.loot_cost, type: 'float'
      xml.tag! 'updated-at', raid_type.updated_at.xmlschema, type: 'datetime'
      xml.tag! 'created-at', raid_type.created_at.xmlschema, type: 'datetime'
    end
  end
end
