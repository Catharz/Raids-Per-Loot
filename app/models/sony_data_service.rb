class SonyDataService
  include RemoteConnectionHelper

  attr_internal_reader :requester_id, :guild_name, :server_name

  def initialize
    @requester_id = APP_CONFIG['soe_query_id']
    @guild_name = APP_CONFIG['guild_name']
    @server_name = APP_CONFIG['eq2_server']
  end

  def update_character_list
    guild_details = download_guild_characters.with_indifferent_access
    return -1 if guild_details.empty?

    updates = 0
    character_list = guild_details[:guild_list][0][:member_list]
    character_list.keep_if { |soe_char| soe_char[:type] and soe_char[:type][:level] >= MIN_LEVEL and soe_char[:type][:level] <= MAX_LEVEL }
    character_list.each do |soe_char|
      character = Character.find_or_create_by_name(soe_char[:name])
      unless character.persisted?
        updates += 1
        character.char_type = 'g'
        character.save!
      end
    end
    updates
  end

  def update_character_details(characters, params)
    characters.each do |character|
      if params[:delayed]
        Delayed::Job.enqueue(CharacterDetailsJob.new(character))
      else
        fetch_soe_character_details(character)
      end
    end
  end

  def update_player_list
    guild_details = download_guild_characters('json', '&c:resolve=members(guild.rank,type.level)').with_indifferent_access
    return -1 if guild_details.empty?

    updates = 0
    character_list = guild_details[:guild_list][0][:member_list]
    rank_list = guild_details[:guild_list][0][:rank_list]
    rank_list.keep_if { |rank| !(['Officer alt', 'Officer alt ', 'Alternate'].include? rank[:name].chomp) }
    character_list.keep_if { |soe_char| soe_char[:type] and soe_char[:type][:level] >= MIN_LEVEL and soe_char[:type][:level] <= MAX_LEVEL }
    character_list.keep_if do |soe_char|
      soe_char[:guild] and soe_char[:guild][:rank] and rank_list.map {|rank| rank[:id]}.include? soe_char[:guild][:rank]
    end
    character_list.each do |soe_char|
      player = Player.find_by_name(soe_char[:name])
      if player.nil?
        updates += 1
        player = Player.create(name: soe_char[:name], rank_id: Rank.find_by_name('Main').id)
        player.save!
      end
    end
    updates
  end

  def fetch_character_details(character)
    if internet_connection?
      json_data = soe_character_data('json')
      character_details = json_data ? json_data['character_list'][0] : HashWithIndifferentAccess.new

      if character_details.nil? or character_details.empty?
        false
      else
        unless character.archetype and character.archetype.name.eql? character_details['type']['class']
          character.update_attribute(:archetype, Archetype.find_by_name(character_details['type']['class']))
        end
        character.build_external_data(:data => character_details)
        character.external_data.save
        true
      end
    else
      true
    end
  end

  def character_statistics(format = "json")
    if internet_connection?
      url = "/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/guild/?c:limit=1&name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}&c:resolve=members(type,stats,alternateadvancements.spentpoints,alternateadvancements.availablepoints,type,equipmentslot_list.item.id,equipmentslot_list.item.adornment_list)".gsub(" ", "%20")
      guild = SOEData.get(url)
      characters = guild["guild_list"].empty? ? [] : guild["guild_list"][0]["member_list"]

      characters.each do |character|
        rpl_char = Character.find_by_name(character['name'])
        if rpl_char
          character['char_type'] = rpl_char.char_type
          character['rpl_id'] = rpl_char.id
          base_class = rpl_char.archetype ? archetype_roots[rpl_char.archetype.name] : nil
        else
          character['rank'] = 'Unknown'
        end
        base_class ||=
            if character.has_key? 'type'
              archetype_roots[character['type']['class']]
            else
              'Unknown'
            end
        character['type'] = Hash.new unless character.has_key? 'type'
        base_class ||= 'Unknown'
        character['type']['base_class'] = base_class
      end
      characters
    else
      []
    end
  end

  private
  def archetype_roots
    @archetype_roots ||= Archetype.root_list
  end

  def character_data(format = "json")
    SOEData.get("/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/character/?name.first=#{name}&locationdata.world=#{APP_CONFIG["eq2_server"]}&c:limit=500&c:show=name.first,name.last,quests.complete,collections.complete,level,alternateadvancements.spentpoints,alternateadvancements.availablepoints,type,resists,skills,spell_list,stats,guild.name")
  end

  def download_guild_characters(format = "json", params = "")
    if internet_connection?
      guild_details_url = "/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/guild/?name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}#{params}".gsub(" ", "%20")
      @guild_details ||= SOEData.get(guild_details_url)
    else
      {}
    end
  end
end