class LootTypeObserver < ActiveRecord::Observer
  observe LootType

  def after_save(loot_type)
    loot_type.items.each do |item|
      item.drops.each do |drop|
        drop.update_attribute(:loot_type, loot_type) unless drop.loot_type.eql? loot_type
      end
    end
    if %w{t g}.include? loot_type.default_loot_method
      loot_type.drops.each do |drop|
        drop.update_attribute(:loot_method, loot_type.default_loot_method) unless drop.loot_method.eql? loot_type.default_loot_method
      end
    end
  end
end