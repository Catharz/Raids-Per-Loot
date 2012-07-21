module CharactersHelper
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