# @author Craig Read
#
# LootMethodHelper provides helper methods for
# selecting loot methods for drops.
module LootMethodHelper
  def loot_method_select(form, field)
    form.select(field, [{:id => 'n', :text => 'Need'}, {:id => 'r', :text => 'Random'}, {:id => 'b', :text => 'Bid'}, {:id => 'g', :text => 'Guild Bank'}, {:id => 't', :text => 'Trash'}, {:id => 'm', :text => 'Transmuted'}].collect {|lt| [ lt[:text], lt[:id] ] })
  end

  def loot_method_description(loot_method)
    case loot_method
      when 'n' then 'Need'
      when 'r' then 'Random'
      when 'b' then 'Bid'
      when 'g' then 'Guild Bank'
      when 't' then 'Trash'
      when 'm' then 'Transmuted'
      else 'Unknown'
    end
  end
end