module CharactersHelper
  def char_type_select(form, field)
    form.select(field, [{:id => 'm', :text => 'Raid Main'}, {:id => 'r', :text => 'Raid Alternate'}, {:id => 'g', :text => 'General Alternate'}].collect {|ct| [ ct[:text], ct[:id] ] })
  end

  def char_type_name(char_type)
    case char_type
      when "m" then
        "Raid Main"
      when "r" then
        "Raid Alternate"
      else
        "General Alternate"
    end
  end

  def health_rating(health, base_class)
    case base_class
      when 'Fighter'
        if health.to_i >= 55000
          "optimal"
        else
          if health.to_i >= 50000
            "minimal"
          else
            "unsatisfactory"
          end
        end
      when 'Priest'
        if health.to_i >= 50000
          "optimal"
        else
          if health.to_i >= 45000
            "minimal"
          else
            "unsatisfactory"
          end
        end
      else
        if health.to_i >= 45000
          "optimal"
        else
          if health.to_i >= 40000
            "minimal"
          else
            "unsatisfactory"
          end
        end
    end
  end

  def crit_rating(crit)
    if crit.to_f >= 310.0
      "optimal"
    else
      if crit.to_f >= 285.0
        "minimal"
      else
        "unsatisfactory"
      end
    end
  end

  def adornment_rating(adornments)
    if adornments >= 75.0
      "optimal"
    else
      if adornments >= 50.0
        "minimal"
      else
        "unsatisfactory"
      end
    end
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