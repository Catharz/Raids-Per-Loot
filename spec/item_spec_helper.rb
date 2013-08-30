module ItemSpecHelper
  def valid_item_attributes(options = {})
    loot_type = mock_model(LootType, name: "Armour")
    {
        loot_type_id: loot_type.id,
        name: "Armour Item",
        :eq2_item_id => "1223"
    }.merge!(options)
  end

  def item_as_json(item)
    {'sEcho' => 0,
     'iTotalRecords' => 1,
     'iTotalDisplayRecords' => 1,
     'aaData' => [
         {
             '0' => '<a href="/items/' + item.id.to_s +
                 '" class="itemPopupTrigger">Whatever</a>',
             '1' => nil,
             '2' => 'None',
             '3' => 'None',
             '4' => '<a href="/items/' + item.id.to_s +
                 '" class="table-button">Show</a>',
             '5' => '<a href="/items/' + item.id.to_s +
                 '/edit" class="table-button">Edit</a>',
             '6' => '<a href="/items/' + item.id.to_s +
                 '" class="table-button" data-confirm="Are you sure?" ' +
                 'data-method="delete" rel="nofollow">Destroy</a>',
             'DT_RowId' => item.id
         }
     ]
    }
  end
end