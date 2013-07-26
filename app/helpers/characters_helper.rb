module CharactersHelper

  def char_type_select(form, field)
    form.select(field, character_type_options)
  end

  def character_type_options
    [{:id => 'm', :text => 'Raid Main'}, {:id => 'r', :text => 'Raid Alternate'}, {:id => 'g', :text => 'General Alternate'}].collect {|ct| [ ct[:text], ct[:id] ] }
  end

  def char_type_name(char_type)
    case char_type
      when 'm' then
        'Raid Main'
      when 'r' then
        'Raid Alternate'
      else
        'General Alternate'
    end
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
    case archetype_root
      when 'Fighter'
        if health.to_i >= 65000
          'optimal'
        else
          if health.to_i >= 60000
            'minimal'
          else
            'unsatisfactory'
          end
        end
      when 'Priest'
        if health.to_i >= 60000
          'optimal'
        else
          if health.to_i >= 55000
            'minimal'
          else
            'unsatisfactory'
          end
        end
      else
        if health.to_i >= 55000
          'optimal'
        else
          if health.to_i >= 50000
            'minimal'
          else
            'unsatisfactory'
          end
        end
    end
  end

  def crit_rating
    if critical_chance >= 420.0
      'optimal'
    else
      if critical_chance >= 350.0
        'minimal'
      else
        'unsatisfactory'
      end
    end
  end

  def adornment_rating
    if adornment_pct >= 75.0
      'optimal'
    else
      if adornment_pct >= 50.0
        'minimal'
      else
        'unsatisfactory'
      end
    end
  end

  def adornment_data
    {
        white_adornments: adornment_stats('white'),
        yellow_adornments: adornment_stats('yellow'),
        red_adornments: adornment_stats('red'),
        green_adornments: adornment_stats('green'),
        blue_adornments: adornment_stats('blue')
    }
  end

  def character_row_data(character = self)
    {
        player_raids: character.player.raids_count,
        raids: character.raids_count,
        instances: character.instances_count,
        armour: character.armour_count,
        jewellery: character.jewellery_count,
        weapons: character.weapons_count,
        attuned: character.armour_count + character.jewellery_count + character.weapons_count,
        adornments: character.adornments_count,
        dislodgers: character.dislodgers_count,
        mounts: character.mounts_count,
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