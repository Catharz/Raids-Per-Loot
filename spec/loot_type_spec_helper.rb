module LootTypeSpecHelper
  def create_loot_type(loot_type_name)
    mock_model(LootType, name: loot_type_name)
  end
end