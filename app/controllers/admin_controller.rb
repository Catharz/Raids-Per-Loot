class AdminController < ApplicationController
  include RemoteConnectionHelper
  before_filter :login_required

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
      character_list = guild_details[:guild_list][0][:member_list]
      character_list.each do |soe_char|
        character = Character.find_or_create_by_name(soe_char[:name])
        unless character.persisted?
          character.char_type = "g"
          character.save!
        end
      end
    end

    redirect_to '/admin'
  end

  private
  def download_guild_characters(format = "json")
    if internet_connection?
      guild_details_url = "/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/guild/?name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}".gsub(" ", "%20")
      @guild_details ||= SOEData.get(guild_details_url)
    else
      {}
    end
  end
end