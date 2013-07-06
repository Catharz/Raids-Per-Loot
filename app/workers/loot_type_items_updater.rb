class LootTypeItemsUpdater
  @queue = :loot_type_item_updater

  def self.perform(loot_type_id)
    loot_type = LootType.find(loot_type_id)

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