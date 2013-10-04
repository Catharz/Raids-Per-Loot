xml.instruct!
xml.rank do
  xml.id @rank.id, type: 'integer'
  xml.name @rank.name
  if @rank.priority.nil?
    xml.priority nil, :nil => true
  else
    xml.priority @rank.priority, type: 'integer'
  end
  xml.tag! 'created-at', @rank.created_at.xmlschema, type: 'datetime'
  xml.tag! 'updated-at', @rank.updated_at.xmlschema, type: 'datetime'
end