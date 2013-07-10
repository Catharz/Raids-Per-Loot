module PlayersHelper
  def player_row_data(player = self)
    {

        raids: player.raids_count,
        instances: player.instances_count,
        armour: player.armour_count,
        jewellery: player.jewellery_count,
        weapons: player.weapons_count,
        attuned: player.armour_count + player.jewellery_count + player.weapons_count,
        adornment: player.adornments_count,
        dislodgers: player.dislodgers_count,
        mounts: player.mounts_count,
        player_id: player.id
    }
  end
end
