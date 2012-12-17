class AdminController < ApplicationController
  include RemoteConnectionHelper
  before_filter :login_required
  MIN_LEVEL = 90
  MAX_LEVEL = 95

  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def fix_trash_drops
    incorrect_trash_drops = 0
    Item.of_type("Trash").each do |item|
      item.drops.where('loot_method <> ?', 't').each do |drop|
        incorrect_trash_drops += 1
        drop.loot_method = 't'
        drop.save
      end
    end
    if incorrect_trash_drops.eql? 0
      flash.notice = "There were no trash drops to fix"
    else
      flash.notice = "Set #{incorrect_trash_drops} drops of trash items to the correct loot method"
    end
    redirect_to '/admin'
  end

  def resolve_duplicate_items
    if Item.resolve_duplicates
      flash.notice = "Item duplicates resolved successfully"
    else
      flash.alert = "Some Item Duplicates Left Unresolved"
    end

    redirect_to '/admin'
  end

  def update_character_list
    #TODO: Refactor this out and get it into a central class or gem for dealing with Sony Data
    guild_details = download_guild_characters.with_indifferent_access
    if guild_details.empty?
      flash.alert = "Could not retrieve character list"
    else
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
    end

    redirect_to '/admin', :notice => "#{updates} characters downloaded"
  end

  def update_player_list
    guild_details = download_guild_characters("json", "&c:resolve=members(guild.rank,type.level)").with_indifferent_access
    if guild_details.empty?
      flash.alert = "Could not retrieve character list"
    else
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
    end

    redirect_to '/admin', :notice => "#{updates} players downloaded"
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