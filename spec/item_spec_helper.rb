module ItemSpecHelper
  def valid_item_attributes(options = {})
    loot_type = mock_model(LootType, :name => "Armour")
    {
        :loot_type_id => loot_type.id,
        :name => "Armour Item",
        :eq2_item_id => "1223"
    }.merge!(options)
  end
end