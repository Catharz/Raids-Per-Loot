# @author Craig Read
#
# LootMethodHelper provides helper methods for
# selecting loot methods for drops.
module LootMethodHelper
  def loot_method_select(form, field)
    form.select(field, [{:id => 'n', :text => 'Need'},
                        {:id => 'r', :text => 'Random'},
                        {:id => 'b', :text => 'Bid'},
                        {:id => 'g', :text => 'Guild Bank'},
                        {:id => 't', :text => 'Trash'},
                        {:id => 'm', :text => 'Transmuted'}].
        collect { |lt| [lt[:text], lt[:id]] })
  end

  def loot_method_description(loot_method)
    return 'Need' if loot_method == 'n'
    return 'Random' if loot_method == 'r'
    return 'Bid' if loot_method == 'b'
    return 'Guild Bank' if loot_method == 'g'
    return 'Trash' if loot_method == 't'
    return 'Transmuted' if loot_method == 'm'
    'Unknown'
  end
end