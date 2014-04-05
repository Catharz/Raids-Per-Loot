# @author Craig Read
#
# CharactersHelper provides helper methods for
# the character related views.
module CharactersHelper

  def char_type_select(form, field)
    form.select(field, character_type_options)
  end

  def character_type_options
    [{:id => 'm', :text => 'Raid Main'},
     {:id => 'r', :text => 'Raid Alternate'},
     {:id => 'g', :text => 'General Alternate'}].collect { |ct| [ct[:text], ct[:id]] }
  end

  def confirmed_rating_select(form, field)
    form.select(field, confirmed_rating_options, include_blank: true)
  end

  def confirmed_rating_options
    [{:id => 'unsatisfactory', :text => 'Unsatisfactory'},
     {:id => 'minimum', :text => 'Minimum'},
     {:id => 'optimal', :text => 'Optimal'}].collect { |ct| [ct[:text], ct[:id]] }
  end

  def confirmed_rating_name(rating)
    return 'Optimal' if rating.eql? 'o'
    return 'Minimum' if rating.eql? 'm'
    'Unsatisfactory'
  end

  def char_type_name(char_type)
    return 'Raid Main' if char_type.eql? 'm'
    return 'Raid Alternate' if char_type.eql? 'r'
    'General Alternate'
  end

  def data
    return {} if external_data.nil?
    return {} unless external_data['data'].present?
    external_data['data']
  end

  def level
    data.fetch('type', {}).fetch('level', 0)
  end

  def health
    data.fetch('stats', {}).fetch('health', {}).fetch('max', 0)
  end

  def power
    data.fetch('stats', {}).fetch('power', {}).fetch('max', 0)
  end

  def critical_chance
    data.fetch('stats', {}).fetch('combat', {}).fetch('critchance', 0.0)
  end

  def crit_bonus
    data.fetch('stats', {}).fetch('combat', {}).fetch('critbonus', 0.0)
  end

  def potency
    data.fetch('stats', {}).fetch('combat', {}).fetch('basemodifier', 0.0)
  end

  def alternate_advancement_points
    data.fetch('alternateadvancements', {}).fetch('spentpoints', 0) +
        data.fetch('alternateadvancements', {}).fetch('availablepoints', 0)
  end

  def overall_rating
    return 'unsatisfactory' if data.empty?

    ratings = %w{unsatisfactory minimal optimal}
    ratings[[health_rating, crit_rating, adornment_rating].
                collect { |r| ratings.index(r) }.min]
  end

  def health_rating
    return 'optimal' if health.to_i >= optimal_health(archetype_root)
    return 'minimal' if health.to_i >= minimal_health(archetype_root)
    'unsatisfactory'
  end

  def optimal_health(archetype)
    return 550000 if archetype.eql? 'Fighter'
    350000
  end

  def minimal_health(archetype)
    return 500000 if archetype.eql? 'Fighter'
    300000
  end

  def crit_rating
    return 'optimal' if critical_chance >= 600.0
    return 'minimal' if critical_chance >= 580.0
    'unsatisfactory'
  end

  def adornment_rating
    return 'optimal' if adornment_pct >= 75.0
    return 'minimal' if adornment_pct >= 50.0
    'unsatisfactory'
  end

  def adornment_data
    {
        white_adornments: adornment_stats('white'),
        yellow_adornments: adornment_stats('yellow'),
        red_adornments: adornment_stats('red'),
        green_adornments: adornment_stats('green'),
        blue_adornments: adornment_stats('blue'),
        purple_adornments: adornment_stats('purple')
    }
  end

  def character_row_data(character = self)
    row_data = attendance_stats character
    row_data.merge! attuned_loot_stats character
    row_data.merge! misc_loot_stats character
    row_data.merge! other_stats character
  end

  def attendance_stats(character = self)
    {
        player_raids: character.player.raids_count,
        raids: character.raids_count,
        instances: character.instances_count
    }
  end

  def attuned_loot_stats(character = self)
    {
        armour: character.armour_count,
        jewellery: character.jewellery_count,
        weapons: character.weapons_count,
        attuned: character.armour_count + character.jewellery_count + character.weapons_count
    }
  end

  def misc_loot_stats(character = self)
    {
        adornments: character.adornments_count,
        dislodgers: character.dislodgers_count,
        mounts: character.mounts_count
    }
  end

  def other_stats(character = self)
    {
        switches: character.player_switches_count,
        character_id: character.id,
        health: character.health,
        power: character.power,
        critical_chance: character.critical_chance,
        adornment_percentage: character.adornment_pct
    }
  end

  def adornment_stats(color = nil)
    possible_adornments, total_adornments = count_adornments(color)
    "#{total_adornments} / #{possible_adornments}"
  end

  def adornment_pct(color = nil)
    possible_adornments, total_adornments = count_adornments(color)
    possible_adornments > 0 ? (total_adornments.to_f / possible_adornments.to_f) * 100.0 : 0
  end

  def count_adornments(color = nil)
    possible_adornments = 0
    total_adornments = 0

    slots = data.fetch('equipmentslot_list', [])
    slots.each do |slot|
      adornment_slots = slot.fetch('item', {}).fetch('adornment_list', [])
      adornment_slots.each do |adornment_slot|
        slot_color = adornment_slot.fetch('color', nil)
        has_adornment = adornment_slot.fetch('id', false)
        if slot_color.eql? color or color.nil?
          possible_adornments += 1
          total_adornments += 1 if has_adornment
        end
      end
    end

    return possible_adornments, total_adornments
  end
end
