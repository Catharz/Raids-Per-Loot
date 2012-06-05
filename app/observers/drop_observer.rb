class DropObserver < ActiveRecord::Observer
  observe Drop

  def after_create(drop)
    get_item_details(drop)
    update_caches(drop)
  end

  def after_save(drop)
    get_item_details(drop)
    update_caches(drop)
  end

  private

  def get_item_details(drop)
    if drop.item
      Delayed::Job.enqueue(ItemDetailsJob.new(drop.item.name))
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