module CharactersHelper
  def char_type_select(form, field)
    form.select(field, [{:id => 'm', :text => 'Raid Main'}, {:id => 'r', :text => 'Raid Alternate'}, {:id => 'g', :text => 'General Alternate'}].collect {|ct| [ ct[:text], ct[:id] ] })
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

  def health_rating(health, base_class)
    case base_class
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

  def crit_rating(crit)
    if crit.to_f >= 420.0
      'optimal'
    else
      if crit.to_f >= 350.0
        'minimal'
      else
        'unsatisfactory'
      end
    end
  end

  def adornment_rating(adornments)
    if adornments >= 75.0
      'optimal'
    else
      if adornments >= 50.0
        'minimal'
      else
        'unsatisfactory'
      end
    end
  end

  def adornment_data(character)
    {
        white_adornments: adornment_stats(character, 'white'),
        yellow_adornments: adornment_stats(character, 'yellow'),
        red_adornments: adornment_stats(character, 'red'),
        green_adornments: adornment_stats(character, 'green'),
        blue_adornments: adornment_stats(character, 'blue')
    }
  end

  def attendance_stats(character)
    {
        raids: character.raids_count,
        instances: character.instances_count,
        armour: character.armour_count,
        jewellery: character.jewellery_count,
        weapon: character.weapon_count
    }
  end

  def adornment_stats(character, color = nil)
    possible_adornments, total_adornments = count_adornments(character, color)
    "#{total_adornments} / #{possible_adornments}"
  end

  def adornment_pct(character, color = nil)
    possible_adornments, total_adornments = count_adornments(character, color)
    possible_adornments > 0 ? (total_adornments.to_f / possible_adornments.to_f) * 100.0 : 0
  end

  def count_adornments(character, color = nil)
    possible_adornments = 0
    total_adornments = 0

    unless character['equipmentslot_list'].nil?
      character['equipmentslot_list'].each do |slot|
        unless slot['item'].nil? or slot['item']['adornment_list'].nil?
          slot['item']['adornment_list'].each do |adornment_slot|
            if adornment_slot['color'].eql? color or color.nil?
              possible_adornments += 1
              total_adornments += 1 if adornment_slot['id']
            end
          end
        end
      end
    end

    return possible_adornments, total_adornments
  end
end