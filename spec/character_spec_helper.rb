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
    characters.each do |character_name|
      rank = Rank.find_or_create_by_name("#{character_name} Rank")
      archetype = Archetype.find_or_create_by_name("#{character_name} Archetype")

      player = Player.find_by_name(character_name)
      player ||= Player.create(:name => character_name, :rank_id => rank.id)

      unless Character.find_by_name(character_name)
        Character.create(:name => character_name, :player => player, :archetype => archetype, :char_type => 'm')
      end
    end
    Character.all
  end
end