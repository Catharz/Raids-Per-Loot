# @author Craig Read
#
# ItemObserver manages updating the loot_method
# of associated Drops when the Item loot type is
# set to trash
class ItemObserver < ActiveRecord::Observer
  observe :item

  def after_save(item)
    item.drops.each do |drop|
      drop.update_attribute(:loot_type, item.loot_type) unless item.loot_type.nil? or drop.loot_type.eql? item.loot_type
      if item.loot_type.name.eql? "Trash"
        drop.update_attribute(:loot_method, "t") unless drop.loot_method.eql? "t"
      end
    end
  end
end
