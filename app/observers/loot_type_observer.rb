class LootTypeObserver < ActiveRecord::Observer
  observe LootType

  def after_save(loot_type)
    loot_type.items.each do |item|
      item.drops.each do |drop|
        drop.update_attribute(:loot_type, loot_type) unless drop.loot_type.eql? loot_type
      end
    end
    if loot_type.default_loot_method.eql? 't'
      loot_type.drops.each do |drop|
        drop.update_attribute(:loot_method, 't') unless drop.loot_method.eql? 't'
      end
    end
  end
end