json.sEcho params[:sEcho]
json.iTotalRecords Drop.count
json.iTotalDisplayRecords @drops.count
json.aaData(@drops) do |drop|
  json.set! '0', h(link_to drop.item_name, drop.item, class: 'itemPopupTrigger')
  json.set! '1', drop.character_name
  json.set! '2', drop.loot_type_name
  json.set! '3', drop.zone_name
  json.set! '4', drop.mob_name
  json.set! '5', drop.drop_time
  json.set! '6', drop.loot_method_name
  json.set! '7', h(link_to 'Show', drop, class: 'table-button')
  json.set! '8', h(link_to 'Edit', edit_drop_path(drop), class: 'table-button')
  json.set! '9', h(link_to 'Destroy', drop, :confirm => 'Are you sure?', :method => :delete, class: 'table-button')
  json.set! 'DT_RowId', drop.item.id
end