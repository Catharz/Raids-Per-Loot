class DropAssignmentValidator
  def initialize(drop)
    @drop, @character, @item, @loot_type = drop, drop.character, drop.item, drop.loot_type
    @issues = []
  end

  def validate
    @issues << 'Drop / Item Type Mismatch' unless @loot_type.eql? @item.loot_type
    if @character
      case @drop.loot_method
        when 'n'
          validate_need_assignment
        when 'r'
          validate_random_assignment
        when 'b'
          validate_bid_assignment
        when 'g'
          unless @item.loot_type and @item.loot_type.default_loot_method.eql? 'g'
            @issues << 'Loot via Guild Bank for non-Guild Bank Item'
          end
        else
          unless @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
            @issues << 'Loot via Trash for Non-Trash item'
          end
      end
    else
      @issues << 'No Character for Drop'
    end
    @issues
  end

  private
  def validate_bid_assignment
    if @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
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
    if @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
      @issues << 'Loot via Random on Trash Item'
    else
      if @item.loot_type and @item.loot_type.default_loot_method.eql? 'g'
        unless @item.archetypes.empty?
          unless @character.archetype and @item.archetypes.include? @character.archetype
            @issues << 'Item / Character Class Mis-Match'
          end
        end
      else
        if @character.raid_alternate(@drop.drop_time).eql? @character
          unless @character.archetype and @item.archetypes.include? @character.archetype
            @issues << 'Item / Character Class Mis-Match'
          end
        else
          @issues << 'Loot via Random for Non-Raid Alt'
        end
      end
    end
  end

  def validate_need_assignment
    if @item.loot_type and @item.loot_type.default_loot_method.eql? 't'
      @issues << 'Loot via Need for Trash Item'
    else
      if @item.loot_type and @item.loot_type.default_loot_method.eql? 'g'
        @issues << 'Loot via Need for Guild Bank Item'
      else
        if @character.general_alternates(@drop.drop_time).include? @character
          @issues << 'Loot via Need for General Alternate'
        else
          unless @character.archetype and @item.archetypes.include? @character.archetype
            @issues << 'Item / Character Class Mis-Match'
          end
        end
      end
    end
  end
end