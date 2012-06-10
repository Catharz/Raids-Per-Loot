class DropObserver < ActiveRecord::Observer
  observe Drop

  def after_save(drop)
    if drop.character
      drop.character.recalculate_loot_rates
      if drop.character.player
        drop.character.player.recalculate_loot_rates
      end
    end
    drop.item.update_item_details
  end

  def helpers
    ActionController::Base.helpers
  end

  private
  def get_item_details(drop)
    if drop.item
      ItemDetailsJob.new(drop.item)
    end
  end

  def update_caches(drop)
    if drop.character
      update_model_cache(drop.character)
      update_model_cache(drop.character.player) if drop.character.player
    end
  end

  def update_model_cache(model)
    model.armour_rate = model.loot_rate("Armour")
    model.jewellery_rate = model.loot_rate("Jewellery")
    model.weapon_rate = model.loot_rate("Weapon")
    model.save
  end
end