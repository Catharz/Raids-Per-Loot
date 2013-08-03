require 'will_paginate/array'

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
      characters.paginate(page: page, per_page: per_page).map do |char|
      character = Character.find(char['id'].to_i)
      {
          '0' => h(link_to character.name, character, :id => "char_#{character.id}_#{character.char_type}", remote: true),
          '1' => character.current_main ? h(link_to character.current_main_name, character.current_main, :id => "#{character.current_main.id}", remote: true) : nil,
          '2' => character.player ? h(link_to character.player_name, character.player) : nil,
          '3' => character.archetype_name,
          '4' => character.first_raid_date,
          '5' => character.last_raid_date,
          '6' => character.raids_count,
          '7' => character.instances_count,
          '8' => @view.number_with_precision(character.armour_rate, precision: 2),
          '9' => @view.number_with_precision(character.jewellery_rate, precision: 2),
          '10' => @view.number_with_precision(character.weapon_rate, precision: 2),
          '11' => h(link_to 'Edit', @view.edit_character_path(character), remote: true, class: 'table-button'),
          '12' => h(link_to 'Update', @view.fetch_data_character_path(character), :confirm => 'Are you sure?', class: 'table-button'),
          '13' => h(link_to 'Destroy', character, :confirm => 'Are you sure?', :method => :delete, remote: true, class: 'table-button'),
          'DT_RowId' => "character_#{character.id}_#{params[:char_type]}",
          'data' => character.character_row_data
      }
    end
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

    if params[:sSearch].present?
      search_string = "'%#{params[:sSearch].upcase}%'"
      character_sql << " where (upper(characters.name) like #{search_string}"
      character_sql << " or    upper(main.name) like #{search_string}"
      character_sql << " or    upper(players.name) like #{search_string}"
      character_sql << " or    upper(archetypes.name) like #{search_string}"
      character_sql << " or    upper(parent.name) like #{search_string}"
      character_sql << " or    upper(root.name) like #{search_string}"
      character_sql << " or    upper(case characters.char_type when 'm' then 'Raid Main' when 'r' then 'Raid Alternate' else 'General Alternate' end) like #{search_string}"
      character_sql << " or    CAST((select min(raid_date) from raids left outer join player_raids on player_raids.player_id = characters.player_id where raids.id = player_raids.raid_id) as TEXT) like #{search_string}"
      character_sql << " or    CAST((select max(raid_date) from raids left outer join player_raids on player_raids.player_id = characters.player_id where raids.id = player_raids.raid_id) as TEXT) like #{search_string})"
      character_sql << " and characters.char_type = '#{params[:char_type]}'" if params[:char_type] != 'all'
    else
      character_sql << " where characters.char_type = '#{params[:char_type]}'" if params[:char_type] != 'all'
    end

    character_sql << " order by #{sort_column} #{sort_direction}"

    Character.connection.select_all(character_sql)
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
    columns =['characters.name',
              'main.name',
              'players.name',
              'archetypes.name',
              'first_raid',
              'last_raid',
              'characters.raids_count',
              'characters.instances_count',
              'characters.armour_rate',
              'characters.jewellery_rate',
              'characters.weapon_rate']
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
  end
end