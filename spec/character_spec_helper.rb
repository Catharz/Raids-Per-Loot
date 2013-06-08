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

  def valid_soe_attributes(options = {})
    {
        'name' => 'Character',
        'char_type' => 'm',
        'type' => {
            'class' => 'Monk',
            'base_class' => 'Fighter',
            'level' => 92
        },
        'alternateadvancements' => {
            'spentpoints' => 320,
            'availablepoints' => 0
        },
        'stats' => {
            'health' => {'max' => 50000},
            'power' => {'max' => 40000},
            'combat' => {
                'critchance' => 285.0,
                'critbonus' => 212.02,
                'basemodifier' => 215.15
            }
        },
        'equipmentslot_list' => [
            {'item' => {'adornment_list' => [{'color' => 'white', 'id' => '1'},
                                             {'color' => 'yellow', 'id' => '2'},
                                             {'color' => 'red', 'id' => '3'}]}}
        ]
    }.merge!(options)
  end

  def setup_characters(characters)
    character_list = []
    characters.each do |character_name|
      rank = mock_model(Rank, :name => "#{character_name} Rank")
      archetype = mock_model(Archetype, :name => "#{character_name} Archetype")
      player = mock_model(Player, :name => character_name, :rank => rank)
      character_list << mock_model(Character,
                                   name: character_name,
                                   player: player,
                                   archetype: archetype,
                                   char_type: 'm',
                                   first_raid_date: '2012-01-01',
                                   last_raid_date: '2013-02-31')
    end
    character_list
  end
end