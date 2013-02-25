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
        character.char_type = "g"
        character.save!
      end
    end
    updates
  end

  def update_player_list
    guild_details = download_guild_characters("json", "&c:resolve=members(guild.rank,type.level)").with_indifferent_access
    return -1 if guild_details.empty?

    updates = 0
    character_list = guild_details[:guild_list][0][:member_list]
    rank_list = guild_details[:guild_list][0][:rank_list]
    rank_list.keep_if { |rank| !(["Officer alt", "Officer alt ", "Alternate"].include? rank[:name].chomp) }
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

  private
  def download_guild_characters(format = "json", params = "")
    if internet_connection?
      #guild_details_url = "/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/guild/?name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}#{params}".gsub(" ", "%20")
      guild_details_url = "/#{format}/get/eq2/guild/?name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}#{params}".gsub(" ", "%20")
      @guild_details ||= SOEData.get(guild_details_url)
    else
      {}
    end
  end
end