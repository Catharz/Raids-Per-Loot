# @author Craig Read
#
# DropPreProcessor sets the loot type of a drop
# based on its item
class DropPreProcessor
  @queue = :drop_pre_processor

  def self.perform(drop_id)
    Drop.paper_trail_off
    drop = Drop.find(drop_id)

    assign_loot_type(drop) if drop.loot_type.nil?
    Drop.paper_trail_on
  end

  def self.assign_loot_type(drop)
    unless drop.item.nil? or drop.item.loot_type.nil?
      drop.loot_type = drop.item.loot_type
      drop.loot_method = drop.item.loot_type.default_loot_method
    end
  end
end