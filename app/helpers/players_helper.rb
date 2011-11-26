module PlayersHelper
  def generate_sub_nav(params = {})
    archetype = params[:archetype]
    sort = params[:sort]
    result = <<-eos
      <div id='subnav'>
        <ul>
    eos
    if !archetype
      Archetype.main_classes.each do |main_class|
        nav_url = "/players?archetype=#{main_class.name}"
        nav_url = "#{nav_url}&sort=#{sort}" unless !sort
        nav_text = "#{main_class.name}s"
        result += "<li>#{ link_to nav_text, nav_url}</li>"
      end
    else
      nav_url = '/players'
      nav_url = "#{nav_url}?sort=#{sort}" unless !sort
      nav_text = 'Back'
      result += "<li>#{ link_to nav_text, nav_url}</li>"
    end
    result += <<-eos
        </ul>
      </div>
    eos
    result.html_safe
  end

  def generate_headings(params = {})
    archetype = params[:archetype]
    sort = params[:sort]
    headings = ""
    LootType.all.each do |loot_type|
      heading_text = "#{loot_type.name} Rate"
      if (sort == loot_type.name)
        column_heading = "<th>#{heading_text}</th>"
      else
        heading_url = "/players?sort=#{loot_type.name}"
        if archetype
          heading_url = "#{heading_url}&archetype=#{archetype}"
        end
        column_heading = "<th>#{link_to heading_text, heading_url}</th>"
      end
      headings += column_heading
    end
    headings.html_safe
  end
end
