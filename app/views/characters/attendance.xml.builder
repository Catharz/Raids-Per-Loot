xml.instruct!
xml.tag! 'characters', type: 'array' do
  @characters.each do |character|
    xml.character do
      xml.id character.id, type: 'integer'
      xml.name character.name
      xml.attendance character.attendance, type: 'float'
    end
  end
end
