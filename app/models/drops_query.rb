# @author Craig Read
#
# DropsQuery handles searching, pagination and sorting
# based on params passed to it
class DropsQuery
  attr_reader :params, :total_records, :total_entries, :drops

  def initialize(params = {})
    @params = params
    @drops = fetch_drops
    @total_records = Drop.count
    @total_entries = @drops.total_entries
  end

  private

  def fetch_drops(drops = Drop.scoped)
    drops = filter(drops)
    drops = search(drops)
    drops = pre_load(drops)
    drops = sort(drops)
    paginate(drops)
  end

  def filter(scope)
    scope.by_eq2_item_id(params[:eq2_item_id]) \
      .by_time(params[:drop_time]).by_instance(params[:instance_id]) \
      .by_zone(params[:zone_id]).by_mob(params[:mob_id]) \
      .by_player(params[:player_id]).by_character(params[:character_id]) \
      .by_item(params[:item_id])
  end

  def search(scope)
    return scope unless params[:sSearch].present?
    scope.where('upper(zones.name) like :search or ' +
                    'upper(mobs.name) like :search or ' +
                    'upper(items.name) like :search or ' +
                    'upper(characters.name) like :search or ' +
                    'upper(loot_types.name) like :search',
                search: "%#{params[:sSearch].upcase}%")
  end

  def pre_load(scope)
    scope.eager_load(:instance, :zone, :mob, :character, :item, :loot_type)
  end

  def sort(scope)
    scope.order("#{sort_column} #{sort_direction}")
  end

  def paginate(scope)
    scope.page(page).per_page(per_page)
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
end