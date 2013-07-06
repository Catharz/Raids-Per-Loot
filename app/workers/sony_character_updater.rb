include RemoteConnectionHelper

class SonyCharacterUpdater
  @queue = :sony_character_updater

  def self.perform(character_id)
    character = Character.find(character_id)
    raise Exception, 'Internet connection unavailable.' unless internet_connection?

    character_details = SonyDataService.new.character_data(character.name, 'json')

    if character_details.nil? or character_details.fetch('character_list', [])[0].empty?
      raise Exception, "Could not obtain character details for #{character.name}"
    else
      archetype_name = character_details.fetch('character_list')[0].fetch('type', {}).fetch('class')
      unless character.archetype_name.eql? archetype_name
        character.update_attribute(:archetype, Archetype.find_by_name(archetype_name))
      end

      character.external_data.delete
      character.build_external_data(data: character_details)
      character.external_data.save
    end
  end
end