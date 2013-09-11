require 'spec_helper'
require 'url_spec_helper'

describe SonyDataService do
  include UrlSpecHelper
  fixtures :archetypes, :ranks

  subject { SonyDataService.new }
  let(:guild_details) { {guild_list: [
      member_list: [
          {name: {first: 'France'}, guild: {rank: 0}, type: {level: 90}},
          {name: {first: 'Francis'}, guild: {rank: 0}, type: {level: 95}},
          {name: {first: 'Franky'}, guild: {rank: 1}, type: {level: 92}},
          {name: {first: 'Franko'}, guild: {rank: 1}, type: {level: 90}},
          {name: {first: 'Freddy'}, guild: {rank: 2}, type: {level: 90}},
          {name: {first: 'Freda'}, guild: {rank: 2}, type: {level: 95}},
          {name: {first: 'Freddo'}, guild: {rank: 3}, type: {level: 96}},
          {name: {first: 'Frodo'}, guild: {rank: 3}, type: {level: 95}},
          {name: {first: 'Grace'}, guild: {rank: 4}, type: {level: 95}},
          {name: {first: 'Gracie'}, guild: {rank: 4}, type: {level: 96}},
          {name: {first: 'Grendle'}, guild: {rank: 5}, type: {level: 95}},
          {name: {first: 'Gretta'}, guild: {rank: 5}, type: {level: 96}},
          {name: {first: 'Harry'}, guild: {rank: 6}, type: {level: 96}},
          {name: {first: 'Harriette'}, guild: {rank: 6}, type: {level: 95}},
          {name: {first: 'Henry'}, guild: {rank: 7}, type: {level: 93}},
          {name: {first: 'Henrique'}, guild: {rank: 7}, type: {level: 90}},
          {name: {first: 'Heratio'}, guild: {rank: 8}}
      ],
      rank_list: [
          {id: 0, name: 'Guild Leader'},
          {id: 1, name: 'Officer'},
          {id: 2, name: 'Officer alt'},
          {id: 3, name: 'The Honored'},
          {id: 4, name: 'The Loyal'},
          {id: 5, name: 'Member'},
          {id: 6, name: 'Alternate'},
          {id: 7, name: 'Recruit'}
      ]]}.with_indifferent_access
  }

  describe '#get_base_class' do
    it 'sets the base class to Unknown if the hash is empty' do
      subject.get_base_class({}).should eq 'Unknown'
    end

    it 'queries calls archetypes_roots to find it' do
      subject.get_base_class({type: {class: 'Monk'}}.with_indifferent_access).
          should eq 'Fighter'
    end
  end

  describe '#update_character_list' do
    let(:names) { %w{Francis Franky Freda Frodo Grace Grendle Harriette Henry} }
    it 'should return -1 if no details are available' do
      subject.stub(:internet_connection?).and_return(false)

      subject.update_character_list.should eq -1
    end

    it 'should use SOEData to get the guild details' do
      subject.stub(:internet_connection?).and_return(true)

      SOEData.should_receive(:get).with(guild_path('Southern Cross', 'Unrest')).and_return(guild_details)
      subject.update_character_list
    end

    it 'only includes characters that are within the level range required' do
      subject.should_receive(:download_guild_characters).and_return(guild_details)
      names.each do |name|
        character = FactoryGirl.create(:character, name: name)
        Character.stub(:find_or_create_by_name).and_return(character)
        character.stub(:persisted?).and_return(true)
      end
      subject.update_character_list
    end

    it 'adds new characters as general alternates' do
      subject.should_receive(:download_guild_characters).and_return(guild_details)
      names.each do |name|
        character = FactoryGirl.create(:character, name: name)
        Character.should_receive(:find_or_create_by_name).with(name).and_return(character)
        character.stub(:persisted?).and_return(false)
        character.should_receive(:char_type=).with('g')
        character.should_receive(:save!)
      end
      subject.update_character_list
    end
  end

  describe '#update_character_details' do
    it 'uses Resque and the SonyCharacterUpdater to update each character' do
      characters = [FactoryGirl.create(:character)]
      Resque.should_receive(:enqueue).with(SonyCharacterUpdater, characters[0].id)
      subject.update_character_details(characters)
    end
  end

  describe '#update_player_list' do
    it 'should return -1 if no details are available' do
      subject.stub(:download_guild_characters).and_return({})

      subject.update_player_list.should eq -1
    end

    it 'only creates players of the appropriate ranks' do
      names = %w(France Francis Franko Franky Freddo Frodo Grace Gracie Grendle Gretta Henrique Henry)
      subject.stub(:download_guild_characters).and_return(guild_details)
      subject.update_player_list.should eq 12
      Player.all.collect { |p| p.name }.should match_array names
    end
  end

  describe '#character_statistics' do
    before(:each) do
      monk = Archetype.find_by_name('Monk')
      conjuror = Archetype.find_by_name('Conjuror')
      warden = Archetype.find_by_name('Warden')
      troubador = Archetype.find_by_name('Troubador')
      FactoryGirl.create(:character, name: 'Francis', archetype: monk)
      FactoryGirl.create(:character, name: 'Franky', archetype: conjuror)
      FactoryGirl.create(:character, name: 'Freda', archetype: warden)
      FactoryGirl.create(:character, name: 'Frodo', archetype: troubador)
    end

    it 'returns an empty array when there is no internet connection' do
      subject.stub(:internet_connection?).and_return(false)
      subject.character_statistics.should eq []
    end

    it 'sets the rank to Unknown if they are not in the database' do
      subject.stub(:internet_connection?).and_return(true)
      SOEData.stub(:get).and_return(guild_details)

      subject.character_statistics.reject { |c| c[:rank] == 'Unknown' }.collect { |c| c[:name][:first] }.
          should match_array Character.all.collect { |c| c.name }
    end

    it 'sets the base class to Unknown if there is no type information' do
      small_guild_list = {guild_list: [member_list: [
          {name: {first: 'Sam'}, guild: {rank: 0}}],
                                       rank_list: [
                                           {id: 0, name: 'Guild Leader'},
                                           {id: 1, name: 'Officer'},
                                           {id: 2, name: 'Officer alt'},
                                           {id: 3, name: 'The Honored'},
                                           {id: 4, name: 'The Loyal'},
                                           {id: 5, name: 'Member'},
                                           {id: 6, name: 'Alternate'},
                                           {id: 7, name: 'Recruit'}]
      ]}.with_indifferent_access

      subject.stub(:internet_connection?).and_return(true)
      SOEData.stub(:get).and_return(small_guild_list)

      subject.character_statistics[0][:type][:base_class].should eq 'Unknown'
    end

    context 'retrieves database values for' do
      it 'character type' do
        subject.stub(:internet_connection?).and_return(true)
        SOEData.stub(:get).and_return(guild_details)

        stats = subject.character_statistics.select { |c| c[:char_type].present? }.
          collect { |c| [c[:name][:first], c[:char_type]] }
        stats.should match_array Character.all.collect { |c| [c.name, c.char_type] }
        stats.should_not eq []
      end

      it 'character id' do
        subject.stub(:internet_connection?).and_return(true)
        SOEData.stub(:get).and_return(guild_details)

        stats = subject.character_statistics.select { |c| c[:rpl_id].present? }.
            collect { |c| [c[:name][:first], c[:rpl_id]] }
        stats.should match_array Character.all.collect { |c| [c.name, c.id] }
        stats.should_not eq []
      end

      it 'base class' do
        subject.stub(:internet_connection?).and_return(true)
        SOEData.stub(:get).and_return(guild_details)

        stats = subject.character_statistics.select { |c| c[:type][:base_class] != 'Unknown' }.
            collect { |c| [c[:name][:first], c[:type][:base_class]] }
        stats.should match_array Character.all.collect { |c| [c.name, c.archetype_root] }
        stats.should_not eq []
      end
    end
  end

  describe '#character_data' do
    it 'queries the character data with the server and character name' do
      SOEData.should_receive(:get).with(character_path('Fred', 'Unrest', 'xml')).and_return({})
      subject.character_data('Fred', 'xml')
    end

    it 'queries using json by default' do
      SOEData.should_receive(:get).with(character_path('Fred', 'Unrest')).and_return({})
      subject.character_data('Fred')
    end

    it 'gets the base class from the database if required' do
      FactoryGirl.create(:character, name: 'Jahjah', archetype: Archetype.find_by_name('Monk'))
      data = {character_list: [{name: {first: 'Jahjah'}, type: {}, guild: {rank: 0}}]}.with_indifferent_access
      SOEData.should_receive(:get).with(character_path('Jahjah', 'Unrest')).and_return(data)

      subject.character_data('Jahjah')['type']['base_class'].should eq 'Fighter'
    end
  end

  describe '#item_data' do
    it 'uses SOEData to retrieve the data' do
      dummy_item_list = {item_list: %w{Blah}}.with_indifferent_access
      SOEData.stub(:get).and_return(dummy_item_list)
      subject.item_data(1234).should eq 'Blah'
    end

    it 'converts the id to base 2 if it is negative' do
      dummy_item_list = {item_list: %w{Blah}}.with_indifferent_access
      SOEData.should_receive(:get).with(item_path('4294966062', 'xml')).and_return(dummy_item_list)
      subject.item_data(-1234, 'xml').should eq 'Blah'
    end

    it 'uses json by default' do
      dummy_item_list = {item_list: %w{Blah}}.with_indifferent_access
      SOEData.should_receive(:get).with(item_path('4294966062')).and_return(dummy_item_list)
      subject.item_data(-1234).should eq 'Blah'
    end
  end

  describe '#combat_statistics' do
    it 'uses SOEData to retrieve the data' do
      SOEData.should_receive(:get).with(character_stats_path('John', 'Unrest', 'xml'))
      subject.combat_statistics('John', 'xml')
    end

    it 'uses json by default' do
      SOEData.should_receive(:get).with(character_stats_path('Jane', 'Unrest'))
      subject.combat_statistics('Jane')
    end
  end

  describe '#resolve_duplicates' do
    it 'cleans up duplicate eq2 item ids' do
      relation = double(ActiveRecord::Relation)
      item1 = FactoryGirl.create(:item, name: 'duplicate item 1', eq2_item_id: 1234)
      item2 = FactoryGirl.create(:item, name: 'duplicate item 2', eq2_item_id: 1234)

      Item.should_receive(:where).with(eq2_item_id: '1234').and_return(relation)
      relation.should_receive(:order).with(:id).and_return([item1, item2])
      subject.resolve_duplicate_items
    end

    it 'cleans up the drops associated with the duplicate item(s)' do
      relation = double(ActiveRecord::Relation)
      item1 = FactoryGirl.create(:item, name: 'duplicate item 1', eq2_item_id: 1234)
      item2 = FactoryGirl.create(:item, name: 'duplicate item 2', eq2_item_id: 1234)
      drops = Array.new(5) { |index| FactoryGirl.create(:drop, item: item2) }
      item2.stub(:drops).and_return(drops)

      Item.should_receive(:where).with(eq2_item_id: '1234').and_return(relation)
      relation.should_receive(:order).with(:id).and_return([item1, item2])

      drops.each do |drop|
        drop.should_receive(:update_attribute).with(:item_id, item1.id)
      end
      subject.resolve_duplicate_items
    end

    it 'deletes the duplicate item(s)' do
      relation = double(ActiveRecord::Relation)
      item1 = FactoryGirl.create(:item, name: 'duplicate item 1', eq2_item_id: 1234)
      item2 = FactoryGirl.create(:item, name: 'duplicate item 2', eq2_item_id: 1234)

      Item.should_receive(:where).with(eq2_item_id: '1234').and_return(relation)
      relation.should_receive(:order).with(:id).and_return([item1, item2])

      item2.stub(:drops).and_return([])
      item2.should_receive(:delete)
      subject.resolve_duplicate_items
    end
  end

  describe '#character_list' do
    it 'returns an empty array when there is no internet connection' do
      subject.stub(:internet_connection?).and_return(false)
      subject.character_list.should eq []
    end

    it 'uses SOEData when there is an internet connection' do
      subject.stub(:internet_connection?).and_return(true)
      SOEData.should_receive(:get).with(guild_path('Southern Cross', 'Unrest', 'xml')).and_return(guild_details)
      subject.character_list('xml', '')
    end

    it 'uses json by default' do
      url_path = guild_path('Southern Cross', 'Unrest') + '&c:show=member_list'
      subject.stub(:internet_connection?).and_return(true)
      SOEData.should_receive(:get).with(url_path).and_return(guild_details)
      subject.character_list
    end

    it 'resolves the member list by default' do
      url_path = guild_path('Southern Cross', 'Unrest', 'xml') + '&c:show=member_list'
      subject.stub(:internet_connection?).and_return(true)
      SOEData.should_receive(:get).with(url_path).and_return(guild_details)
      subject.character_list('xml')
    end
  end

  describe '#guild_achievements' do
    it 'returns an empty array when there is no internet connection' do
      subject.stub(:internet_connection?).and_return(false)
      subject.guild_achievements.should eq []
    end

    it 'uses guild_data to obtain the data' do
      empty_achievements_list = {guild_list: [achievement_list: []]}.with_indifferent_access
      subject.stub(:internet_connection?).and_return(true)
      subject.should_receive(:guild_data).with('xml', '&c:show=achievement_list').and_return(empty_achievements_list)
      subject.guild_achievements('xml')
    end

    it 'resolves individual achievements' do
      achievement = {id: 1234}.with_indifferent_access
      achievement_details = {
          achievement_list: [{
                                 id: 1234,
                                 description: 'Flawless Victory!'}
          ]}.with_indifferent_access
      achievements_list = {guild_list: [achievement_list: [achievement]]}.with_indifferent_access
      subject.stub(:internet_connection?).and_return(true)
      url_path = '/json/get/eq2/guild/?name=Southern%20Cross' + '&world=Unrest&c:show=achievement_list'
      SOEData.should_receive(:get).with(url_path).and_return(achievements_list)
      SOEData.should_receive(:get).with('/json/get/eq2/achievement/1234').and_return(achievement_details)

      subject.guild_achievements.should eq [achievement_details[:achievement_list][0]]
    end
  end
end