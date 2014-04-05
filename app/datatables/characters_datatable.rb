require 'will_paginate/array'

# @author Craig Read
#
# CharactersDataTable handles searching, pagination
# and formatting json output appropriately for use
# in a server-side data table
class CharactersDatatable
  include CharactersHelper
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Character.count,
        iTotalDisplayRecords: characters.count,
        aaData: data
    }
  end

  private

  def data
    paginated_characters.map do |char|
      character = Character.find(char['id'].to_i)
      character_data = character_stats(character)
      character_data.merge! character_links(character)
      character_data.merge!({
          'DT_RowId' => "character_#{character.id}_#{params[:char_type]}",
          'data' => character.character_row_data})
    end
  end

  def character_stats(character)
    stats = {}
    stats['3'] = character.archetype_name
    stats['4'] = character.first_raid_date
    stats['5'] = character.last_raid_date
    stats['6'] = character.raids_count
    stats['7'] = character.instances_count
    stats['8'] = armour_rate(character)
    stats['9'] = jewellery_rate(character)
    stats['10'] = weapon_rate(character)
    stats
  end

  def character_links(character)
    links = {}
    links['0'] = link_to_show_character(character)
    links['1'] = link_to_show_current_main(character)
    links['2'] = link_to_show_player(character)
    links['11'] = link_to_edit_character(character)
    links['12'] = link_to_fetch_character_data(character)
    links['13'] = link_to_destroy_character(character)
    links
  end

  def link_to_show_character(character)
    character.path(id: "char_#{character.id}_#{character.char_type}", remote: true)
  end

  def link_to_edit_character(character)
    h(link_to 'Edit', @view.edit_character_path(character), remote: true, class: 'table-button')
  end

  def link_to_fetch_character_data(character)
    h(link_to 'Update', @view.fetch_data_character_path(character), confirm: 'Are you sure?', class: 'table-button')
  end

  def link_to_destroy_character(character)
    h(link_to 'Destroy', character, :confirm => 'Are you sure?', method: :delete, remote: true, class: 'table-button')
  end

  def link_to_show_player(character)
    character.player ? character.player.path : nil
  end

  def link_to_show_current_main(character)
    character.current_main ? character.current_main.path(id: "#{character.current_main.id}", remote: true) : nil
  end

  def armour_rate(character)
    @view.number_with_precision(character.armour_rate, precision: 2)
  end

  def jewellery_rate(character)
    @view.number_with_precision(character.jewellery_rate, precision: 2)
  end

  def weapon_rate(character)
    @view.number_with_precision(character.weapon_rate, precision: 2)
  end

  def paginated_characters
    characters.paginate(page: page, per_page: per_page)
  end

  def characters
    @characters ||= fetch_characters
  end

  def fetch_characters
    character_sql =
        <<-eos
select characters.id,
  main.id as main_id,
  characters.player_id,
  characters.name as character_name,
  main.name as main_name,
  players.name as player_name,
  archetypes.name as archetype_name,
  parent.name as archetype_parent,
  root.name as archetype_root,
  (select min(raid_date)
   from raids
   left outer join player_raids on player_raids.player_id = characters.player_id
   where raids.id = player_raids.raid_id
  ) as first_raid,
  (select max(raid_date)
   from raids
   left outer join player_raids on player_raids.player_id = characters.player_id
   where raids.id = player_raids.raid_id
  ) as last_raid,
  characters.raids_count,
  characters.instances_count,
  characters.armour_rate,
  characters.jewellery_rate,
  characters.weapon_rate
from characters
left outer join characters as main on main.player_id = characters.player_id and main.char_type = 'm'
left outer join players on players.id = characters.player_id
left outer join archetypes on archetypes.id = characters.archetype_id
left outer join archetypes as parent on parent.id = archetypes.parent_id
left outer join archetypes as root on root.id = parent.parent_id
    eos

    build_search_string(character_sql)

    character_sql << " order by #{sort_column} #{sort_direction}"

    Character.connection.select_all(character_sql)
  end

  def build_search_string(character_sql)
    if params[:sSearch].present?
      search_string = "'%#{params[:sSearch].upcase}%'"
      character_sql << " where (upper(characters.name) like #{search_string}"
      character_sql << " or    upper(main.name) like #{search_string}"
      character_sql << " or    upper(players.name) like #{search_string}"
      character_sql << " or    upper(archetypes.name) like #{search_string}"
      character_sql << " or    upper(parent.name) like #{search_string}"
      character_sql << " or    upper(root.name) like #{search_string}"
      character_sql << " or    upper(case characters.char_type when 'm' then 'Raid Main' " +
          "when 'r' then 'Raid Alternate' else " +
          "'General Alternate' end) like #{search_string}"
      character_sql << " or    CAST((select min(raid_date) from raids " +
          "left outer join player_raids on player_raids.player_id = characters.player_id " +
          "where raids.id = player_raids.raid_id) as TEXT) like #{search_string}"
      character_sql << " or    CAST((select max(raid_date) from raids " +
          "left outer join player_raids on player_raids.player_id = characters.player_id " +
          "where raids.id = player_raids.raid_id) as TEXT) like #{search_string})"
      character_sql << " and characters.char_type = '#{params[:char_type]}'" if params[:char_type] != 'all'
    else
      character_sql << " where characters.char_type = '#{params[:char_type]}'" if params[:char_type] != 'all'
    end
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
    columns = %w(characters.name main.name players.name archetypes.name
                first_raid last_raid characters.raids_count
                characters.instances_count characters.armour_rate
                characters.jewellery_rate characters.weapon_rate)
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
  end
end
