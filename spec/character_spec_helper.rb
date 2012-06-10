module CharacterSpecHelper
  def valid_character_attributes(options = {})
    @main_rank ||= Rank.find_or_create_by_name('Main')
    @alternate_rank ||= Rank.find_or_create_by_name('General Alternate')
    @mage ||= Archetype.find_or_create_by_name('Mage')

    @player = Player.find_by_name('Uber')
    @player ||= Player.create(:name => 'Uber', :rank_id => @main_rank.id)
    {:name => 'Fred',
     :archetype_id => @mage.id,
     :char_type => 'm',
     :player_id => @player.id}.merge!(options)
  end

  def setup_characters(characters)
    character_list = []
    characters.each do |character_name|
      rank = mock_model(Rank, :name => "#{character_name} Rank")
      archetype = mock_model(Archetype, :name => "#{character_name} Archetype")
      player = mock_model(Player, :name => character_name, :rank => rank)
      character_list << mock_model(Character, :name => character_name, :player => player, :archetype => archetype, :char_type => "m")
    end
    character_list
  end
end