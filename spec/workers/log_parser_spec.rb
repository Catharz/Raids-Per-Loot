require 'spec_helper'

describe LogParser do
  fixtures :zones, :raid_types, :loot_types
  subject { LogParser }
  let(:file_name) { Rails.root.join('spec/fixtures/files/eq2log_Catharz.txt').to_s }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  context 'instance methods' do
    describe '#perform' do
      it 'creates an eq2 log parser' do
        parser = double Eq2LogParser
        parser.stub :parse
        parser.stub(:raid_list).and_return []
        expect(Eq2LogParser).to receive(:new).with(file_name).and_return parser

        subject.perform file_name
      end

      it 'calls parse on the eq2 log parser' do
        Eq2LogParser.any_instance.should_receive :parse
        Eq2LogParser.any_instance.stub(:raid_list).and_return []

        subject.perform file_name
      end

      it 'calls save_raids if the raid list is not empty' do
        Eq2LogParser.any_instance.should_receive :parse
        Eq2LogParser.any_instance.stub(:raid_list).and_return ['blah']

        expect(subject).to receive :save_raids

        subject.perform file_name
      end
    end

    context 'creates data for' do
      let(:parse) { -> { subject.perform file_name } }
      let(:file_data) { StringIO.new %q{
        (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
        (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
        (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
        (1354411842)[Sat Sep 17 20:11:40 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
        (1354411844)[Sat Sep 17 20:11:40 2011] Daeson hits Prime-Cornicen Munderrad for 3 piercing damage.
        (1354411846)[Sat Sep 17 20:11:40 2011] Chiteira hits Prime-Cornicen Munderrad for 30000 slashing damage.
        (1354411848)[Sat Sep 17 20:11:41 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
        (1354411850)[Sat Sep 17 20:24:10 2011] Random: Coronary rolls from 1 to 100 on the magic dice...and scores a 2!
        (1354411852)[Sat Sep 17 20:24:12 2011] You loot \aITEM 842968069 -1475883379:Pure Primal Velium Shard\/a from the Exquisite Chest of Prime-Cornicen Munderrad1.
        (1354411854)[Sat Sep 17 20:24:14 2011] \aPC -1 Ryhino:Ryhino\/a says to the guild, "lamo"
        (1354411856)[Sat Sep 17 20:24:16 2011] Chiteira loots \aITEM 1371925287 183231148:Thornskin VIII (Master)\/a from the Exquisite Chest of Prime-Cornicen Munderrad2.
        (1354411858)[Sat Sep 17 20:24:18 2011] \aPC -1 Beodan:Beodan\/a says to the officers, "Its Ryhinos Fault!!!"
        (1354411860)[Sat Sep 17 20:24:20 2011] \aPC -1 Agaris:Agaris\/a says to the raid party, "Grats! :)"
        (1354411890)[Sat Sep 17 20:24:30 2011] Spyce loots \aITEM 595219945 -1154546896:Wand of the Kromzek Warmonger\/a from the Exquisite Chest of Prime-Cornicen Munderrad3.
        (1354411900)[Sat Sep 17 20:30:00 2011] You have entered Southern Cross' Guild Hall.
       }
      }
      let(:player_characters) {
        [
            {player: 'Mitia', characters: [name: 'Mitia', char_type: 'm']},
            {player: 'Beodan', characters: [name: 'Beodan', char_type: 'm']},
            {player: 'Catharz', characters: [name: 'Catharz', char_type: 'm']},
            {player: 'Flecks', characters: [{name: 'Chiteira', char_type: 'r'}, {name: 'Flecks', char_type: 'm'}]},
            {player: 'Daeson', characters: [{name: 'Daeson', char_type: 'r'}, {name: 'Spyce', char_type: 'r'}]}
        ]
      }
      let(:trash) { LootType.find_by_name('Trash') }
      let(:spell) { LootType.find_by_name('Spell') }
      let(:weapon) { LootType.find_by_name('Weapon') }

      example 'raids' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Raid, :count).by 1
      end

      example 'instances' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Instance, :count).by 1
      end

      example 'player raids' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(PlayerRaid, :count).by 5
      end

      example 'character instances' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(CharacterInstance, :count).by 6
      end

      example 'mobs' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Mob, :count).by 3
      end

      example 'items' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Item, :count).by 3
      end

      example 'drops' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Drop, :count).by 3
      end

      context 'a drops chat' do
        example 'including random rolls' do
          File.stub(:open).with(file_name).and_return file_data
          player_characters.each do |pc|
            player = FactoryGirl.create(:player, name: pc[:player])
            pc[:characters].each do |c|
              FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
            end
          end
          shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
          thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
          wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

          expect(parse).to change(Drop, :count).by 3

          drop_chat = Drop.select(:chat).find_by_item_id(shard.id).chat
          expect(drop_chat).to include 'Random: Coronary rolls from 1 to 100'
        end

        example 'including guild chat' do
          File.stub(:open).with(file_name).and_return file_data
          player_characters.each do |pc|
            player = FactoryGirl.create(:player, name: pc[:player])
            pc[:characters].each do |c|
              FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
            end
          end
          shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
          thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
          wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

          expect(parse).to change(Drop, :count).by 3

          drop_chat = Drop.select(:chat).find_by_item_id(shard.id).chat
          expect(Drop.select(:chat).find_by_item_id(thornskin.id).chat).to include "Ryhino:Ryhino\\/a says to the guild, \"lamo\""
        end

        example 'including officer chat' do
          File.stub(:open).with(file_name).and_return file_data
          player_characters.each do |pc|
            player = FactoryGirl.create(:player, name: pc[:player])
            pc[:characters].each do |c|
              FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
            end
          end
          shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
          thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
          wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

          expect(parse).to change(Drop, :count).by 3

          drop_chat = Drop.select(:chat).find_by_item_id(wand.id).chat
          expect(drop_chat).to include "Beodan:Beodan\\/a says to the officers, \"Its Ryhinos Fault!!!\""
        end

        example 'including raid chat' do
          File.stub(:open).with(file_name).and_return file_data
          player_characters.each do |pc|
            player = FactoryGirl.create(:player, name: pc[:player])
            pc[:characters].each do |c|
              FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
            end
          end
          shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
          thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
          wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

          expect(parse).to change(Drop, :count).by 3

          drop_chat = Drop.select(:chat).find_by_item_id(wand.id).chat
          expect(drop_chat).to include "Agaris:Agaris\\/a says to the raid party, \"Grats! :)\""
        end
      end

      example 'a drops loot type' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end
        shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
        thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
        wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

        expect(parse).to change(Drop, :count).by 3
        expect(Drop.find_by_item_id(shard.id).loot_type_name).to eq 'Trash'
        expect(Drop.find_by_item_id(thornskin.id).loot_type_name).to eq 'Spell'
        expect(Drop.find_by_item_id(wand.id).loot_type_name).to eq 'Weapon'
      end

      example 'a drops default loot method' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end
        shard = FactoryGirl.create(:item, eq2_item_id: 842968069, name: 'Pure Primal Velium Shard', loot_type: trash)
        thornskin = FactoryGirl.create(:item, eq2_item_id: 1371925287, name: 'Thornskin VIII (Master)', loot_type: spell)
        wand = FactoryGirl.create(:item, eq2_item_id: 595219945, name: 'Wand of the Kromzek Warmonger', loot_type: weapon)

        expect(parse).to change(Drop, :count).by 3
        expect(Drop.find_by_item_id(shard.id).loot_method).to eq 't'
        expect(Drop.find_by_item_id(thornskin.id).loot_method).to eq 'g'
        expect(Drop.find_by_item_id(wand.id).loot_method).to eq 'n'
      end

      example 'one run only' do
        File.stub(:open).with(file_name).and_return file_data
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Drop, :count).by 3
        expect(parse).to change(Drop, :count).by 0
      end
    end
  end
end
