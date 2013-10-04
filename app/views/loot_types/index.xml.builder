xml.instruct!
xml.tag! 'loot-types', type: 'array' do
  @loot_types.each do |loot_type|
    xml.tag! 'loot-type' do
      xml.id(loot_type.id, type: 'integer')
      xml.name(loot_type.name)
      xml.tag! 'created-at', loot_type.created_at.xmlschema, type: 'datetime'
      xml.tag! 'updated-at', loot_type.updated_at.xmlschema, type: 'datetime'
      xml.tag! 'default-loot-method', loot_type.default_loot_method
    end
  end
end
