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
          h(link_to drop.item ? drop.item.name : "Unknown", drop),
          drop.character ? drop.character.name : "Unknown",
          drop.loot_type ? drop.loot_type.name : "Unknown",
          drop.zone ? drop.zone.name : "Unknown",
          drop.mob ? drop.mob.name : "Unknown",
          drop.drop_time,
          case drop.loot_method
            when "n" then
              "Need"
            when "r" then
              "Random"
            when "b" then
              "Bid"
            when "t" then
              "Trash"
            else
              "Unknown"
          end,
          h(link_to 'Edit', @view.edit_drop_path(drop)),
          h(link_to 'Destroy', drop, :confirm => 'Are you sure?', :method => :delete)
      ]
    end
  end

  def drops
    @drops ||= fetch_drops
  end

  def fetch_drops
    drops = Drop.by_instance(params[:instance_id]).by_zone(params[:zone_id]).by_mob(params[:mob_id]) \
      .by_player(params[:player_id]).by_character(params[:character_id]).by_item(params[:item_id]) \
      .eager_load(:instance, :zone, :mob, :item => :loot_type, :character => :player) \
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
    columns = %w[items.name characters.name loot_types.name zones.name mobs.name drops.drop_time drops.loot_method]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end