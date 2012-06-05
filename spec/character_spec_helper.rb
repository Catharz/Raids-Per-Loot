module CharacterSpecHelper
  def valid_character_attributes(options = {})
    @main_rank = Factory.create(:rank, :name => 'Main')
    @player = Factory.create(:player, :name => 'Uber', :rank_id => @main_rank)
    @fighter_archetype = Factory.create(:archetype, :name => 'Mage')
    @alternate_rank = Factory.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :archetype_id => @fighter_archetype.id,
     :char_type => 'm',
     :player_id => @player.id}.merge!(options)
  end

  def setup_characters(characters)
    rank_list = []
    player_list = []
    character_list = []
    archetype_list = []
    characters.each do |character_name|
      rank = stub_model(Rank, :name => "#{character_name} Rank")
      rank_list << rank

      player = stub_model(Player, :name => character_name, :rank => rank)
      player_list << player

      archetype = stub_model(Archetype, :name => "#{character_name} Archetype")
      archetype_list << archetype

      character = stub_model(Character, :name => character_name, :player => player, :archetype => archetype)
      character_list << character
    end
    assign(:players, player_list)
    assign(:ranks, rank_list)
    assign(:archetypes, archetype_list)
    assign(:characters, character_list)
    character_list
  end

  def setup_loot(character, looted_items = [])
    raise "You must specify a valid character" if character.nil?

    zone_list = []
    mob_list = []
    drop_list = []
    item_list = []
    looted_items.each do |loot|
      item_count = loot[:count]
      loot_type = stub_model(LootType, :name => loot[:loot_type])
      items = (1..item_count).to_a
      items.each do |n|
        item = stub_model(Item, :name => "#{loot[:loot_type]} Item #{n}", :loot_type => loot_type)
        item_list << item
        drop_list << stub_model(Drop, :item_name => item.name)
      end
    end
  end
end