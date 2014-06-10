xml.instruct!
xml.zone do
  xml.id @zone.id, type: 'integer'
  xml.name @zone.name
  xml.tag! 'created-at', @zone.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @zone.updated_at.xmlschema, type: 'datetime'
  xml.tag! 'difficulty-id', @zone.difficulty_id, type: 'integer'
end
