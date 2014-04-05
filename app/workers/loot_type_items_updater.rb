# @author Craig Read
#
# LootTypeItemsUpdater manages setting the loot type
# of drops when its null, and setting the loot method
# of drops when the default loot method of the loot
# type is trash or guild bank
class LootTypeItemsUpdater
  @queue = :loot_type_item_updater

  def self.perform(loot_type_id)
    loot_type = LootType.find(loot_type_id)

    update_drop_loot_types loot_type
    update_drop_loot_method loot_type
  end

  private
  def self.update_drop_loot_types loot_type
    loot_type.items.each do |item|
      item.drops.each do |drop|
        drop.update_attribute(:loot_type, loot_type) unless drop.loot_type.eql? loot_type
      end
    end
  end

  def self.update_drop_loot_method loot_type
    if %w{t g}.include? loot_type.default_loot_method
      loot_type.drops.each do |drop|
        drop.update_attribute(:loot_method, loot_type.default_loot_method) \
          unless drop.loot_method.eql? loot_type.default_loot_method
      end
    end
  end
end
