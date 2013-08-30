require 'uri'

module UrlSpecHelper
  def guild_path(guild, server, format = 'json')
    "/#{format}/get/eq2/guild/?name=#{URI.escape(guild)}&world=#{server}"
  end

  def character_path(name, server, format = 'json')
    "/#{format}/get/eq2/character/?name.first=#{name}" +
        "&locationdata.world=#{server}&c:show=name.first,name.last," +
        'quests.complete,collections.complete,level,' +
        'alternateadvancements.spentpoints,' +
        'alternateadvancements.availablepoints,type,resists,skills,' +
        'spell_list,stats,guild.name,equipmentslot_list.item.id,' +
        'equipmentslot_list.item.adornment_list'
  end

  def character_stats_path(name, server, format = 'json')
    "/#{format}/get/eq2/character/?name.first=#{name}" +
        "&locationdata.world=#{server}" +
        '&c:limit=500&c:show=name,stats,type,' +
        'alternateadvancements.spentpoints,' +
        'alternateadvancements.availablepoints'
  end

  def item_path(item_id, format = 'json')
    "/#{format}/get/eq2/item/?id=#{item_id}&c:show=type,displayname," +
        'typeinfo.classes,typeinfo.slot_list,slot_list'
  end
end