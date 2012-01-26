module PlayersHelper
  def generate_headings(params = {})
    raid = params[:raid_id]
    sort = params[:sort]
    headings = ""
    LootType.all.each do |loot_type|
      if loot_type.show_on_player_list?
        heading_text = "#{loot_type.name} Rate"
        if (sort == loot_type.name)
          column_heading = "<th>#{heading_text}</th>"
        else
          heading_url = "/raids/#{raid}/players?sort=#{loot_type.name}" if raid
          heading_url ||= "/players?sort=#{loot_type.name}"
          column_heading = "<th>#{link_to heading_text, heading_url}</th>"
        end
        headings += column_heading
      end
    end
    headings.html_safe
  end

  def display_loot_rates(player)
    loot_rates = ""
    LootType.all.each do |loot_type|
       loot_rates += "<td align=\"right\">#{player.loot_rate(loot_type.name)}</td>" if loot_type.show_on_player_list?
    end
    loot_rates.html_safe
  end
end
