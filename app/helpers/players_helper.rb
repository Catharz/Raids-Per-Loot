module PlayersHelper
  def player_row_data(player = self)
    {

        raids: player.raid_count({}, false),
        instances: player.instance_count,
        armour: player.armour_item_count,
        jewellery: player.jewellery_item_count,
        weapons: player.weapon_item_count,
        attuned: player.armour_item_count + player.jewellery_item_count + player.weapon_item_count,
        adornment: player.adornment_item_count,
        dislodgers: player.dislodger_item_count,
        mounts: player.mount_item_count,
        player_id: player.id
    }
  end
end
