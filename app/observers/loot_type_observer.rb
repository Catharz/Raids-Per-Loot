# @author Craig Read
#
# LootTypeObserver queues a job to update its
# associated Drops and Items when its loot method
# is changed
class LootTypeObserver < ActiveRecord::Observer
  observe :loot_type

  def after_save(loot_type)
    Resque.enqueue(LootTypeItemsUpdater, loot_type.id)
  end
end