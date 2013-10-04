xml.instruct!
xml.archetype do
  xml.id @archetype.id, type: 'integer'
  xml.name @archetype.name
  xml.tag! 'created-at', @archetype.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @archetype.updated_at.xmlschema, type: 'datetime'
  if @archetype.parent_id.nil?
    xml.tag! 'parent-id', @archetype.parent_id, {type: 'integer', :nil => true}
  else
    xml.tag! 'parent-id', @archetype.parent_id, type: 'integer'
  end
end