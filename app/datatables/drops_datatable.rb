class DropsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Drop.count,
        iTotalDisplayRecords: drops.total_entries,
        aaData: data
    }
  end

  private

  def data
    drops.map do |drop|
      [
          drop.item_name,
          drop.character_name,
          drop.loot_type_name,
          drop.zone_name,
          drop.mob_name,
          drop.drop_time,
          drop.loot_method_name,
          h(link_to 'Show', drop, class: 'table-button'),
          h(link_to 'Edit', @view.edit_drop_path(drop), class: 'table-button'),
          h(link_to 'Destroy', drop, :confirm => 'Are you sure?', :method => :delete, class: 'table-button')
      ]
    end
  end

  def drops
    @drops ||= fetch_drops
  end

  def fetch_drops
    drops = Drop.by_instance(params[:instance_id]).by_zone(params[:zone_id]).by_mob(params[:mob_id]) \
      .by_player(params[:player_id]).by_character(params[:character_id]).by_item(params[:item_id]) \
      .eager_load(:instance, :zone, :mob, :character, :item, :loot_type) \
      .order("#{sort_column} #{sort_direction}")
    drops = drops.page(page).per_page(per_page)
    if params[:sSearch].present?
      drops = drops.where("upper(zones.name) like :search or upper(mobs.name) like :search or upper(items.name) like :search or upper(characters.name) like :search or upper(loot_types.name) like :search", search: "%#{params[:sSearch].upcase}%")
    end
    drops
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
    if params[:iSortCol_0].present?
      columns = %w[items.name characters.name loot_types.name zones.name mobs.name drops.drop_time drops.loot_method]
      columns[params[:iSortCol_0].to_i]
    else
      'drops.drop_time'
    end
  end

  def sort_direction
    if params[:sSortDir_0].present?
      params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
    else
      sort_column == 'drops.drop_time' ? 'desc' : 'asc'
    end
  end
end