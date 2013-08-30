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
    @issues << validate_need_assignment
    @issues << validate_random_assignment
    if @character
      case @drop.loot_method
        when 'n'
          #validate_need_assignment
        when 'r'
          #validate_random_assignment
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
    if trash_item?
      @issues << 'Loot via Bid on Trash Item'
    else
      if @character.main_character(@drop.drop_time).eql? @character
        @issues << 'Loot via Bid for Raid Main'
      else
        if @character.raid_alternate(@drop.drop_time).eql? @character
          @issues << 'Loot via Bid for Raid Alt'
        else
          unless @character.archetype and @item.archetypes.include? @character.archetype
            @issues << 'Item / Character Class Mis-Match'
          end
        end
      end
    end
  end

  def validate_random_assignment
    return [] unless @drop.loot_method.eql? 'r'
    issues = []
    issues << 'Loot via Random on Trash Item' if trash_item?

    if guild_bank_item?
      issues << 'Item / Character Class Mis-Match' unless archetypes_match?
    else
      if @character.raid_alternate(@drop.drop_time).eql? @character
        issues << 'Item / Character Class Mis-Match' unless archetypes_match?
      else
        issues << 'Loot via Random for Non-Raid Alt'
      end
    end
    issues.flatten
  end

  def validate_need_assignment
    return [] unless @drop.loot_method.eql? 'n'
    issues = []
    issues << 'Loot via Need for Trash Item' if trash_item?
    issues << 'Loot via Need for Guild Bank Item' if guild_bank_item?
    issues << 'Loot via Need for General Alternate' if looted_by_gen_alt?()
    issues << 'Item / Character Class Mis-Match' unless archetypes_match?()
    issues.flatten
  end

  def archetypes_match?
    return true if @item.archetypes.empty? or @character.nil?
    @character.archetype and @item.archetypes.include? @character.archetype
  end

  def looted_by_gen_alt?
    return false if @character.nil?
    @character.general_alternates(@drop.drop_time).include? @character
  end

  def guild_bank_item?
    @item.loot_type and @item.loot_type.default_loot_method.eql? 'g'
  end

  def trash_item?
    @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
  end
end