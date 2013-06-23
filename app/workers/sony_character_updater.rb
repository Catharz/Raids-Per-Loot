include RemoteConnectionHelper

class SonyCharacterUpdater
  @queue = :sony_data_service

  def self.perform(character_id)
    character = Character.find(character_id)
    raise Exception, 'Internet connection unavailable.' unless internet_connection?

    json_data = SonyDataService.new.character_data(character.name, 'json')
    character_details = json_data ? json_data['character_list'][0] : HashWithIndifferentAccess.new

    if character_details.nil? or character_details.empty?
      raise Exception, "Could not obtain character details for #{character.name}"
    else
      unless character.archetype and character.archetype.name.eql? character_details['type']['class']
        character.update_attribute(:archetype, Archetype.find_by_name(character_details['type']['class']))
      end
      character.build_external_data(data: character_details)
      character.external_data.save
    end
  end
end