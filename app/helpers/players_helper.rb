module PlayersHelper
  def generate_sub_nav(params = {})
    raid = params[:raid_id]
    archetype = params[:archetype_id]
    sort = params[:sort]
    result = <<-eos
      <div id='subnav'>
        <ul>
    eos
    if !archetype
      Archetype.main_classes.each do |main_class|
        if raid
          nav_url = "/raids/#{raid}/players?archetype_id=#{main_class.id}"
        else
          nav_url = "/players?archetype_id=#{main_class.id}"
        end
        nav_url = "#{nav_url}&sort=#{sort}" if sort
        nav_text = "#{main_class.name}s"
        result += "<li>#{ link_to nav_text, nav_url}</li>"
      end
    else
      if raid
        nav_url = "/raids/#{raid}/players"
        nav_text = 'All Participants'
      else
        nav_url = "/players"
        nav_text = 'All Players'
      end
      nav_url = "#{nav_url}?sort=#{sort}" if sort
      result += "<li>#{ link_to nav_text, nav_url}</li>"
    end
    result += <<-eos
        </ul>
      </div>
    eos
    result.html_safe
  end

  def generate_headings(params = {})
    archetype = params[:archetype_id]
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
          heading_url = "#{heading_url}&archetype_id=#{archetype}" if archetype
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
