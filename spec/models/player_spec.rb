require 'spec_helper'
require 'rexml/document'

describe Player do
  fixtures :ranks

  let(:player) { FactoryGirl.create(:player,
                                    name: 'Fred',
                                    rank: Rank.find_by_name('Main')) }

  describe 'player' do
    describe 'instance methods' do
      describe '#current_main_name' do
        it 'returns the name of the players current main' do
          current_main = FactoryGirl.create(:character)
          player.stub(:current_main).and_return(current_main)
          player.current_main_name.should eq current_main.name
        end

        it 'returns nil if the player has no current main' do
          player.stub(:current_main).and_return(nil)
          player.current_main_name.should be_nil
        end
      end

      describe '#current_raid_alternate_name' do
        it 'returns the name of the players current raid alternate' do
          current_raid_alternate = FactoryGirl.create(:character)
          player.stub(:current_raid_alternate).and_return(current_raid_alternate)
          player.current_raid_alternate_name.should eq current_raid_alternate.name
        end

        it 'returns nil if the player has no current raid alternate' do
          player.stub(:current_raid_alternate).and_return(nil)
          player.current_raid_alternate_name.should be_nil
        end
      end

      describe '#calculate_loot_rate' do
        it 'should calculate the loot rate with two decimal places' do
          num_raids = 37
          num_items = 5

          loot_rate = player.calculate_loot_rate(num_raids, num_items)
          loot_rate.should == 6.17
        end
      end

      describe '#path' do
        it 'returns a url to the player' do
          player.path.should eq '<a href="/players/' +
                                  player.id.to_s + '">' + player.name + '</a>'
        end

        it 'allows providing options' do
          player.path(format: 'json').should eq '<a href="/players/' +
                                                  player.id.to_s +
                                                  '" format="json">' +
                                                  player.name + '</a>'
        end
      end

      describe '#to_s' do
        it 'shows the players name and their rank' do
          player.to_s.should eq 'Fred (Main)'
        end
      end

      describe '#to_xml' do
        it 'has a root of player' do
          doc = REXML::Document.new(player.to_xml)
          player_element = doc.elements.first
          player_element.name.should eq 'player'
        end

        it 'encodes the players data' do
          doc = REXML::Document.new(player.to_xml)
          player_element = doc.elements.first
          player_element.elements['name'].text.should eq player.name
        end
      end

      describe '#to_csv' do
        it 'should have 14 columns' do
          csv = player.to_csv

          csv.should match('Fred')
          csv.should match('Main')
          csv.split(',').count.should == 14
        end
      end

      describe '#attendance' do
        it 'should return all attendance by default' do
          player.stub(:raids_attended).and_return([1, 2, 3])
          Raid.stub(:for_period).and_return(4)
          player.should_receive(:attendance).and_return(75.00)
          player.attendance.should eq 75.00
        end
      end
    end
  end
end