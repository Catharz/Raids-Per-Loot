xml.instruct!
xml.tag! 'character-instances', type: 'array' do
  @character_instances.each do |character_instance|
    xml.tag! 'character-instance' do
      xml.tag! 'character-id', character_instance.character_id, type: 'integer'
      xml.id(character_instance.id, type: 'integer')
      xml.tag! 'instance-id', character_instance.instance_id, type: 'integer'
    end
  end
end
