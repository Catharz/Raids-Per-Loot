# @author Craig Read
#
# SonyDataService provides a number of functions
# for retrieving data about characters and items
# from http://data.soe.com
class SonyDataService
  include RemoteConnectionHelper

  attr_internal_reader :requester_id, :guild_name, :server_name
  MIN_LEVEL = 92
  MAX_LEVEL = 95

  def initialize
    @guild_name = APP_CONFIG['guild_name']
    @server_name = APP_CONFIG['eq2_server']
  end

  def update_character_list
    guild_details = download_guild_characters.with_indifferent_access
    return -1 if guild_details.empty?

    updates = 0
    character_list = guild_details[:guild_list][0][:member_list]
    character_list.keep_if { |soe_char| soe_char[:type] and
        soe_char[:type][:level] >= MIN_LEVEL and
        soe_char[:type][:level] <= MAX_LEVEL }
    character_list.each do |soe_char|
      character = Character.find_or_create_by_name(soe_char[:name][:first])
      unless character.persisted?
        updates += 1
        character.char_type = 'g'
        character.save!
      end
    end
    updates
  end

  def update_character_details(characters)
    characters.each { |character|
      Resque.enqueue(SonyCharacterUpdater, character.id)
    }
  end

  def update_player_list
    params = '&c:resolve=members(guild.rank,type.level)'
    guild_details = download_guild_characters('json', params).with_indifferent_access
    return -1 if guild_details.empty?

    character_list = guild_details[:guild_list][0][:member_list]
    rank_list = guild_details[:guild_list][0][:rank_list]

    filter_ranks(rank_list)
    filter_characters(character_list, rank_list)
    process_character_list(character_list)
  end

  def character_statistics(format = 'json')
    if internet_connection?
      params = [
          'c:limit=1',
          "name=#{APP_CONFIG['guild_name']}",
          "world=#{APP_CONFIG['eq2_server']}",
          'c:resolve=members(type,stats,alternateadvancements.spentpoints,' +
              'alternateadvancements.availablepoints,type,' +
              'equipmentslot_list.item.id,' + '
              equipmentslot_list.item.adornment_list)'
      ]
      url = "/#{format}/get/eq2/guild/?#{params.join('&')}".gsub(' ', '%20')
      guild = SOEData.get(url)
      characters =
          guild['guild_list'].empty? ? [] :
              guild['guild_list'][0]['member_list']

      return [] if characters.empty?

      characters.each do |character|
        unless character.empty?
          character['type'] ||= {}.with_indifferent_access
          character['type']['base_class'] =
              get_database_details(character) || get_base_class(character)
        end
      end
      characters
    else
      []
    end
  end

  def get_database_details(character)
    rpl_char =
        Character.find_by_name(character.fetch('name', {}).
                                   fetch('first', 'Unknown'))
    if rpl_char
      character['char_type'] = rpl_char.char_type
      character['rpl_id'] = rpl_char.id
      base_class = rpl_char.archetype ? Archetype.
          root_list[rpl_char.archetype.name] : nil
    else
      character['rank'] = 'Unknown'
      base_class = nil
    end
    base_class
  end

  def get_base_class(character)
    archetype_name = character.fetch('type', {}).fetch('class', 'Unknown')
    return archetype_name if archetype_name.eql? 'Unknown'
    Archetype.root_list[archetype_name]
  end

  def character_data(character_name, format = 'json')
    params = [
        "name.first=#{character_name}",
        "locationdata.world=#{APP_CONFIG['eq2_server']}",
        'c:show=name.first,name.last,quests.complete,collections.complete,' +
            'level,alternateadvancements.spentpoints,' +
            'alternateadvancements.availablepoints,type,resists,skills,' +
            'spell_list,stats,guild.name,equipmentslot_list.item.id,' +
            'equipmentslot_list.item.adornment_list'
    ]
    data = SOEData.get("/#{format}/get/eq2/character/?#{params.join('&')}")
    return {} if data['character_list'].nil? or data['character_list'].empty?
    character = data['character_list'].first
    character['type'] ||= {}
    character['type']['base_class'] =
        get_database_details(character) || get_base_class(character)
    character
  end

  def item_data(eq2_item_id, format='json')
    item_id = eq2_item_id.to_i
    if item_id < 0
      item_id = item_id + 2 ** 32
    end
    params = [
        "id=#{item_id}",
        'c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list'
    ]
    json_data = SOEData.get("/#{format}/get/eq2/item/?#{params.join('&')}")
    json_data['item_list'][0]
  end

  def combat_statistics(character_name, format = 'json')
    params = [
        "name.first=#{character_name}",
        "locationdata.world=#{APP_CONFIG['eq2_server']}",
        'c:limit=500&c:show=name,stats,type,' +
            'alternateadvancements.spentpoints,' +
            'alternateadvancements.availablepoints'
    ]
    SOEData.get("/#{format}/get/eq2/character/?#{params.join('&')}")
  end

  def resolve_duplicate_items
    duplicates = Item.group(:eq2_item_id).having(['count(items.id) > 1']).count
    process_duplicates(duplicates)
    (Item.group(:eq2_item_id).having(['count(items.id) > 1']).count).empty?
  end

  def character_list(format = 'json', params = '&c:show=member_list')
    return [] unless internet_connection?

    query_params = %W(
      name=#{APP_CONFIG['guild_name']}
      world=#{APP_CONFIG['eq2_server']})

    members_url =
        "/#{format}/get/eq2/guild/?#{query_params.join('&')}#{params}".
            gsub(' ', '%20')
    guild_details = SOEData.get(members_url)
    guild_details['guild_list'][0]['member_list'].
        map { |m| m['name']['first'] }.sort!
  end

  def guild_achievements(format = 'json')
    return [] unless internet_connection?

    data = guild_data(format, '&c:show=achievement_list')
    achievement_list = data['guild_list'][0]['achievement_list']
    achievement_list.collect { |a| resolve_achievement_data(format, a) }
  end

  private

  def process_character_list(character_list)
    updates = 0
    character_list.each do |soe_char|
      player = Player.find_by_name(soe_char[:name][:first])
      if player.nil?
        updates += 1
        player = Player.create(name: soe_char[:name][:first], rank_id: Rank.find_by_name('Main').id)
        player.save!
      end
    end
    updates
  end

  def filter_characters(character_list, rank_list)
    character_list.keep_if do |soe_char|
      soe_char[:guild] and soe_char[:guild][:rank] and
          rank_list.map { |rank| rank[:id] }.include? soe_char[:guild][:rank]
    end
  end

  def filter_ranks(rank_list)
    rank_list.keep_if { |rank|
      !(['Officer alt', 'Officer alt', 'Alternate'].include? rank[:name].chomp)
    }
  end

  def resolve_achievement_data(format = 'json', value = {})
    if value['id']
      url = "/#{format}/get/eq2/achievement/#{value['id']}"
      data = SOEData.get(url)
      value.merge! data['achievement_list'][0]
    end
  end

  def guild_data(format = 'json', params = '')
    query_params = %W(
      name=#{APP_CONFIG['guild_name']}
      world=#{APP_CONFIG['eq2_server']})
    url = "/#{format}/get/eq2/guild/?#{query_params.join('&')}#{params}".
        gsub(' ', '%20')
    SOEData.get(url)
  end

  def download_guild_characters(format = 'json', params = '')
    return {} unless internet_connection?

    query_params = %W(
      name=#{APP_CONFIG['guild_name']}
      world=#{APP_CONFIG['eq2_server']})

    guild_details_url =
        "/#{format}/get/eq2/guild/?#{query_params.join('&')}#{params}".
            gsub(' ', '%20')
    @guild_details ||= SOEData.get(guild_details_url)
  end

  private
  def process_duplicates(duplicates)
    duplicates.each do |k, v|
      eq2_item_id = k
      duplicate_list = Item.where(eq2_item_id: eq2_item_id).order(:id)
      keep = duplicate_list.first
      duplicate_list.each { |item| remove_duplciates(item, keep.id) unless item.eql? keep }
    end
  end

  def remove_duplciates(item, keep_id)
    item.drops.each do |drop|
      drop.update_attribute(:item_id, keep_id)
    end
    item.delete unless item.drops.count > 0
  end
end