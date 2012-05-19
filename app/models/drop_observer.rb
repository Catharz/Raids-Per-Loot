class DropObserver < ActiveRecord::Observer
  observe Drop

  def after_create(drop)
    get_item_details(drop)
  end

  def after_save(drop)
    get_item_details(drop)
  end

  private

  def get_item_details(drop)
    if drop.item
      Delayed::Job.enqueue(ItemDetailsJob.new(drop.item.name))
    end
  end
end