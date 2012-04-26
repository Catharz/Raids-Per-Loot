module CharacterSpecHelper
  def valid_character_attributes
    @main_rank = Factory.create(:rank, :name => 'Main')
    @player = Factory.create(:player, :name => 'Uber', :rank_id => @main_rank)
    @fighter_archetype = Factory.create(:archetype, :name => 'Mage')
    @alternate_rank = Factory.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :archetype_id => @fighter_archetype.id,
     :char_type => 'm',
     :player_id => @player.id}
  end

  def setup_raids(attendance)
    attendees = attendance[:attendees]
    num_raids = attendance[:num_raids]
    num_instances = attendance[:num_instances]

    zone_list = []
    zones = (1..num_instances).to_a
    zones.each do |zone_num|
      zone_list << stub_model(Zone, :name => "Zone #{zone_num.to_s}")
    end
    assign(:zones, zone_list)

    raid_list = []
    raids = (1..num_raids).to_a
    raids.each do |n|
      raid_list << stub_model(Raid, :raid_date => Date.today - num_raids.days + n.days)
    end
    assign(:raids, raid_list)

    instance_list = []
    raid_list.each do |raid|
      instances = (1..num_instances).to_a
      instances.each do |n|
        instance = stub_model(Instance,
                              :raid => raid,
                              :zone => zone_list[n - 1],
                              :start_time => raid.raid_date + n.hours,
                              :end_time => raid.raid_date + (n + 1).hours,)
        instance_list << instance
        raid.instances << instance
      end
    end
    attendees.each do |character|
      character.stub(:instances).and_return(instance_list)
      character.stub(:raids).and_return(raid_list)
    end
    assign(:instances, instance_list)
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
end