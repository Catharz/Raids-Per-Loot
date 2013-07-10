class DropObserver < ActiveRecord::Observer
  observe :drop

  def before_save(drop)
    Resque.enqueue(DropPreProcessor, drop.id)
  end

  def after_save(drop)
    Resque.enqueue(SonyItemUpdater, drop.item.id) if drop.item
  end
end