require 'spec_helper'

describe LogParser do
  fixtures :zones, :raid_types, :loot_types
  subject { LogParser }
  let(:file_name) { Rails.root.join('spec/fixtures/files/eq2log_Catharz.02.txt').to_s }
  let(:file) { File.open(file_name) }

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
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Raid, :count).by 1
      end

      example 'instances' do
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Instance, :count).by 1
      end

      example 'player raids' do
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(PlayerRaid, :count).by 5
      end

      example 'character instances' do
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(CharacterInstance, :count).by 6
      end

      example 'mobs' do
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Mob, :count).by 3
      end

      example 'items' do
        player_characters.each do |pc|
          player = FactoryGirl.create(:player, name: pc[:player])
          pc[:characters].each do |c|
            FactoryGirl.create(:character, name: c[:name], char_type: c[:char_type], player: player)
          end
        end

        expect(parse).to change(Item, :count).by 3
      end

      example 'drops' do
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
