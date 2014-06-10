xml.instruct!
xml.tag! 'character-instance' do
  xml.tag! 'character-id', @character_instance.character_id, type: 'integer'
  xml.id(@character_instance.id, type: 'integer')
  xml.tag! 'instance-id', @character_instance.instance_id, type: 'integer'
end
