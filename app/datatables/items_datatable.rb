class ItemsDatatable
  include ArchetypesHelper

  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Item.count,
        iTotalDisplayRecords: items.total_entries,
        aaData: data
    }
  end

  private

  def data
    items.map do |item|
      [
          item.name,
          item.loot_type_name,
          item.slot_names,
          consolidate_archetypes(item.archetypes),
          h(link_to 'Show', item, class: 'table-button'),
          h(link_to 'Edit', @view.edit_item_path(item), class: 'table-button'),
          h(link_to 'Destroy', item, :confirm => 'Are you sure?', :method => :delete, class: 'table-button')
      ]
    end
  end

  def items
    @items ||= fetch_items
  end

  #TODO: Get some specs around the searching
  def fetch_items
    items = Item.by_loot_type(params[:loot_type_id]) \
      .eager_load(:loot_type, :items_slots => :slot, :archetypes_items => :archetype) \
      .order("#{sort_column} #{sort_direction}")
    items = items.page(page).per_page(per_page)

    if params[:sSearch].present?
      items = items.where("upper(items.name) like :search or upper(loot_types.name) like :search or upper(archetypes.name) like :search or upper(slots.name) like :search", search: "%#{params[:sSearch].upcase}%")
    end
    items
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
      columns = %w[items.name loot_types.name slots.name archetypes.name]
      columns[params[:iSortCol_0].to_i]
    else
      'items.name'
    end
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end