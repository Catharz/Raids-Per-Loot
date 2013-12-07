include RemoteConnectionHelper

# @author Craig Read
#
# SonyCharacterUpdater manages retrieving character details
# from http://data.soe.com and storing them in ExternalData
class SonyCharacterUpdater
  @queue = :sony_character_updater

  def self.perform(character_id)
    Character.paper_trail_off
    character = Character.find(character_id)
    raise Exception, 'Internet connection unavailable.' unless internet_connection?

    character_details = SonyDataService.new.character_data(character.name, 'json')
    raise Exception, "Could not obtain character details for #{character.name}" unless valid? character_details

    update_archetype(character, character_details)
    update_external_data(character, character_details)
  ensure
    Character.paper_trail_on
  end

  private

  def self.update_external_data(character, character_details)
    character.external_data.delete unless character.external_data.nil?
    character.external_data = character.build_external_data(data: character_details)
  end

  def self.update_archetype(character, character_details)
    archetype_name = character_details.fetch('type', {}).fetch('class')
    unless character.archetype_name.eql? archetype_name
      character.update_attribute(:archetype, Archetype.find_by_name(archetype_name))
    end
  end

  def self.valid?(details)
    true unless details.nil? or details.empty?
  end
end