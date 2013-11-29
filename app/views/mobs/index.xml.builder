xml.instruct!
xml.tag! 'mobs', type: 'array' do
  @mobs.each do |mob|
    xml.tag! 'mob' do
      xml.id(mob.id, type: 'integer')
      xml.name(mob.name)
      if mob.strategy.nil?
        xml.tag! 'strategy', mob.strategy, {:nil => true}
      else
        xml.strategy(mob.strategy)
      end
      xml.tag! 'created-at', mob.created_at.xmlschema, type: 'datetime'
      xml.tag! 'updated-at', mob.updated_at.xmlschema, type: 'datetime'
      xml.tag! 'zone-id', mob.zone_id, type: 'integer'
      xml.tag! 'difficulty-id', mob.difficulty_id, type: 'integer'
      if mob.alias.nil?
        xml.tag! 'alias', mob.alias, {:nil => true}
      else
        xml.alias(mob.alias)
      end
    end
  end
end