class LootTypeObserver < ActiveRecord::Observer
  observe :loot_type

  def after_save(loot_type)
    Resque.enqueue(LootTypeItemsUpdater, loot_type.id)
  end
end