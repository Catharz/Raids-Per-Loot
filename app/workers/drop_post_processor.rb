class DropPostProcessor
  @queue = :data_updates

  def self.perform(drop_id)
    drop = Drop.find(drop_id)

    if drop.character
      drop.character.recalculate_loot_rates
      if drop.character.player
        drop.character.player.recalculate_loot_rates
      end
    end
  end
end