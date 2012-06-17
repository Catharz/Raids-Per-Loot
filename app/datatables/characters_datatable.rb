class CharactersDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Character.count,
        iTotalDisplayRecords: characters.total_entries,
        aaData: data
    }
  end

  private

  def data
    characters.map do |character|
      [
          h(link_to character.name, character, :class => "characterPopupTrigger", :id => "#{character.id}"),
          character.main_character ? h(link_to character.main_character.name, character.main_character) : "Unknown",
          case character.char_type
            when "m" then "Main"
            when "r" then "Raid Alternate"
            else "General Alternate"
          end,
          character.archetype ? character.archetype.name : "Unknown",
          character.archetype && character.archetype.root ? character.archetype.root.name : "Unknown",
          #character.first_raid ? character.first_raid.raid_date : "Never",
          #character.last_raid ? character.last_raid.raid_date : "Never",
          character.raids_count,
          character.instances_count,
          character.armour_rate,
          character.jewellery_rate,
          character.weapon_rate,
          h(link_to 'Destroy', character, :confirm => 'Are you sure?', :method => :delete)
      ]
    end
  end

  def characters
    @characters ||= fetch_characters
  end

  def fetch_characters
    characters = Character.by_player(params[:player_id]).by_instance(params[:instance_id]) \
      .eager_load(:archetype, :character_types, :player => :main_character) \
      .order("#{sort_column} #{sort_direction}")
    characters = characters.page(page).per_page(per_page)
    if params[:sSearch].present?
      characters = characters.where(
          "upper(characters.name) like :search or " +
          "upper(archetypes.name) like :search or " +
          "upper(case characters.char_type when 'm' then 'Raid Main' when 'r' then 'Raid Alternate' else 'General Alternate' end) like :search or " +
          "upper(main_characters_players.name) like :search",
          search: "%#{params[:sSearch].upcase}%")
    end
    characters
  end

  def page
    params[:iDisplayStart] ? params[:iDisplayStart].to_i / per_page + 1 : 1
  end

  def per_page
    if params[:iDisplayLength]
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    else
      10
    end
  end

  def sort_column
    #"SELECT select c.*,         case char_type           when 'm' then 'Raid Main'           when 'r' then 'Raid Alternate'                 else 'General Alternate'                 end as character_rank         from characters FROM "characters"  ORDER BY characters.name asc"
    columns = [
        "characters.name",
        "main_characters_players.name",
        "case characters.char_type when 'm' then 'Raid Main' when 'r' then 'Raid Alternate' else 'General Alternate' end",
        "archetypes.name",
        "archetypes.name",
        "raids_count",
        "instances_count",
        "armour_rate",
        "jewellery_rate",
        "weapon_rate"
    ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end