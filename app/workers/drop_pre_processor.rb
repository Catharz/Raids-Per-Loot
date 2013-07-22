class DropPreProcessor
  @queue = :drop_pre_processor

  def self.perform(drop_id)
    Drop.paper_trail_off
    drop = Drop.find(drop_id)

    if drop.loot_type.nil?
      unless drop.item.nil? or drop.item.loot_type.nil?
        drop.loot_type = drop.item.loot_type
        drop.loot_method = drop.item.loot_type.default_loot_method
      end
    end
    Drop.paper_trail_on
  end
end