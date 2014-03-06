require 'spec_helper'

describe Version do
  describe '#item' do
    example 'returns nil for unknown item types' do
      version = stub_model(Version, item_type: 'Whatever')

      expect(version.item).to be_nil
    end

    context 'finds the appropriate' do
      example 'Character' do
        version = stub_model(Version, item_type: 'Character')

        expect(Character).to receive :find
        version.item
      end

      example 'Player' do
        version = stub_model(Version, item_type: 'Player')

        expect(Player).to receive :find
        version.item
      end

      example 'Drop' do
        version = stub_model(Version, item_type: 'Drop')

        expect(Drop).to receive :find
        version.item
      end
    end
  end

  describe '#previous_version' do
    example 'returns nil for unknown item types' do
      version = stub_model(Version, item_type: 'Whatever')

      expect(version.previous_version).to be_nil
    end

    context 'calls previous_version on' do
      example 'Character' do
        char = FactoryGirl.create(:character)
        version = stub_model(Version, item_id: char.id, item_type: 'Character')

        expect(Character).to receive(:find).and_return char
        expect(char).to receive :previous_version
        version.previous_version
      end

      example 'Player' do
        player = FactoryGirl.create(:player)
        version = stub_model(Version, item_id: player.id, item_type: 'Player')

        expect(Player).to receive(:find).and_return player
        expect(player).to receive :previous_version
        version.previous_version
      end

      example 'Drop' do
        drop = FactoryGirl.create(:drop)
        version = stub_model(Version, item_id: drop.id, item_type: 'Drop')

        expect(Drop).to receive(:find).and_return drop
        expect(drop).to receive :previous_version
        version.previous_version
      end
    end
  end
end
