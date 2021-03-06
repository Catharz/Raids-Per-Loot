# @author Craig Read
#
# DropAssignmentValidator validates a drop against
# using rules covering the loot method and character type
class DropAssignmentValidator
  def initialize(drop)
    @drop, @character, @item, @loot_type =
        drop, drop.character, drop.item, drop.loot_type
    @issues = []
  end

  def validate
    @issues << 'Drop / Item Type Mismatch' unless loot_type_matches?
    @issues << 'No Character for Drop' if @character.nil?
    if @character
      case @drop.loot_method
        when 'n'
          validate_need_assignment
        when 'r'
          validate_random_assignment
        when 'b'
          validate_bid_assignment
        when 'g'
          unless guild_bank_item?
            @issues << 'Loot via Guild Bank for non-Guild Bank Item'
          end
        else
          @issues << 'Loot via Trash for Non-Trash item' unless trash_item?
      end
    else
      @issues << 'No Character for Drop'
    end
    @issues.flatten
  end

  private

  def loot_type_matches?
    @loot_type.eql? @item.loot_type
  end

  def validate_bid_assignment
    @issues << 'Loot via Bid on Trash Item' if trash_item?
    @issues << 'Loot via Bid for Guild Bank Item' if guild_bank_item?
  end

  def validate_random_assignment
    @issues << 'Loot via Random on Trash Item' if trash_item?
  end

  def validate_need_assignment
    @issues << 'Loot via Need for Trash Item' if trash_item?
    @issues << 'Loot via Need for Guild Bank Item' if guild_bank_item?
  end

  def guild_bank_item?
    @item.loot_type and @item.loot_type.default_loot_method.eql? 'g'
  end

  def trash_item?
    @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
  end
end
