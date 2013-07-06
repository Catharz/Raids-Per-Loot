require 'spec_helper'
include CharactersHelper

describe CharactersHelper do
  fixtures :archetypes

  let(:character_data) { {
      equipmentslot_list: [
          item: {
              adornment_list: [
                  {color: 'white', id: 3456},
                  {color: 'white', id: nil},
                  {color: 'yellow', id: 1234},
                  {color: 'red', id: 5678}
              ]}
      ]}.with_indifferent_access
  }
  let(:fighter) { FactoryGirl.create(:character, archetype: Archetype.find_by_name('Monk')) }
  let(:mage) { FactoryGirl.create(:character, archetype: Archetype.find_by_name('Illusionist')) }
  let(:priest) { FactoryGirl.create(:character, archetype: Archetype.find_by_name('Warden')) }
  let(:scout) { FactoryGirl.create(:character, archetype: Archetype.find_by_name('Ranger')) }

  describe '#overall_rating' do
    it 'checks all of the other ratings' do
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('optimal')

      fighter.overall_rating
    end

    it 'is unsatisfactory if any of the ratings are unsatisfactory' do
      fighter.should_receive(:health_rating).and_return('unsatisfactory')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('minimal')

      fighter.overall_rating.should eq 'unsatisfactory'
    end

    it 'is minimal if the worst rating is minimal' do
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('minimal')

      fighter.overall_rating.should eq 'minimal'
    end

    it 'is only optimal if all the ratings are optimal' do
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('optimal')

      fighter.overall_rating.should eq 'optimal'
    end
  end

  describe '#health_rating' do
    context 'Fighter' do
      it 'should be optimal if 65,000 or higher' do
        fighter.should_receive(:health).and_return(65000)
        fighter.health_rating.should eq 'optimal'
      end
      it 'should be minimal if between 60,000 and 65,000' do
        fighter.should_receive(:health).at_least(1).times.and_return(64999)
        fighter.health_rating.should eq 'minimal'
      end
      it 'should be minimal if exactly 60,000' do
        fighter.should_receive(:health).at_least(1).times.and_return(60000)
        fighter.health_rating.should eq 'minimal'
      end
      it 'should be unsatisfactory if below 60,000' do
        fighter.should_receive(:health).at_least(1).times.and_return(59999)
        fighter.health_rating.should eq 'unsatisfactory'
      end
    end

    context 'Priest' do
      it 'should be optimal if 60,000 or higher' do
        priest.should_receive(:health).and_return(60000)
        priest.health_rating.should eq 'optimal'
      end
      it 'should be minimal if between 55,000 and 60,000' do
        priest.should_receive(:health).at_least(1).times.and_return(59999)
        priest.health_rating.should eq 'minimal'
      end
      it 'should be minimal if exactly 55,000' do
        priest.should_receive(:health).at_least(1).times.and_return(55000)
        priest.health_rating.should eq 'minimal'
      end
      it 'should be unsatisfactory if below 55,000' do
        priest.should_receive(:health).at_least(1).times.and_return(54999)
        priest.health_rating.should eq 'unsatisfactory'
      end
    end

    context 'Scout' do
      it 'should be optimal if 55,000 or higher' do
        scout.should_receive(:health).and_return(55000)
        scout.health_rating.should eq 'optimal'
      end
      it 'should be minimal if between 50,000 and 55,000' do
        scout.should_receive(:health).at_least(1).times.and_return(54999)
        scout.health_rating.should eq 'minimal'
      end
      it 'should be minimal if exactly 50,000' do
        scout.should_receive(:health).at_least(1).times.and_return(50000)
        scout.health_rating.should eq 'minimal'
      end
      it 'should be unsatisfactory if below 50,000' do
        scout.should_receive(:health).at_least(1).times.and_return(49999)
        scout.health_rating.should eq 'unsatisfactory'
      end
    end

    context 'Mage' do
      it 'should be optimal if 55,000 or higher' do
        mage.should_receive(:health).and_return(55000)
        mage.health_rating.should eq 'optimal'
      end
      it 'should be minimal if between 50,000 and 55,000' do
        mage.should_receive(:health).at_least(1).times.and_return(54999)
        mage.health_rating.should eq 'minimal'
      end
      it 'should be minimal if exactly 50,000' do
        mage.should_receive(:health).at_least(1).times.and_return(50000)
        mage.health_rating.should eq 'minimal'
      end
      it 'should be unsatisfactory if below 50,000' do
        mage.should_receive(:health).at_least(1).times.and_return(49999)
        mage.health_rating.should eq 'unsatisfactory'
      end
    end
  end

  describe '#crit_rating' do
    it 'should be optimal if 420.0' do
      fighter.should_receive(:critical_chance).and_return(420.0)
      fighter.crit_rating.should eq 'optimal'
    end

    it 'should be minimal if between 350.0 and 420.0' do
      priest.should_receive(:critical_chance).twice.and_return(419.99)
      priest.crit_rating.should eq 'minimal'

      scout.should_receive(:critical_chance).twice.and_return(350.00)
      scout.crit_rating.should eq 'minimal'
    end

    it 'should be unsatisfactory if below 350.0' do
      mage.should_receive(:critical_chance).twice.and_return(349.99)
      mage.crit_rating.should eq 'unsatisfactory'
    end
  end

  describe '#adornment_rating' do
    it 'should be optimal if 75.0 or higher' do
      fighter.should_receive(:adornment_pct).and_return(75.0)
      fighter.adornment_rating.should eq 'optimal'
    end

    it 'should be minimal if between 50.0 and 75.0' do
      priest.should_receive(:adornment_pct).twice.and_return(74.99)
      priest.adornment_rating.should eq 'minimal'

      mage.should_receive(:adornment_pct).twice.and_return(50.00)
      mage.adornment_rating.should eq 'minimal'
    end

    it 'should be unsatisfactory if below 50.0' do
      scout.should_receive(:adornment_pct).twice.and_return(49.99)
      scout.adornment_rating.should eq 'unsatisfactory'
    end
  end

  describe '#adornment_stats' do
    context 'should return valid ratios' do
      it 'for all slots when colour is unspecified' do
        fighter.should_receive(:data).and_return(character_data)
        fighter.adornment_stats.should eq '3 / 4'
      end

      it 'for the specified colour' do
        priest.should_receive(:data).and_return(character_data)
        priest.adornment_stats('white').should eq '1 / 2'
      end
    end
  end

  describe '#adornment_pct' do
    it 'should calculate correctly for all adornments' do
      mage.should_receive(:data).and_return(character_data)
      mage.adornment_pct.should eq 75.00
    end

    it 'should calculate correctly for specific adornments' do
      scout.should_receive(:data).and_return(character_data)
      scout.adornment_pct('white').should eq 50.00
    end
  end

  describe '#count_adornments' do
    it 'should return valid values for all slots' do
      fighter.should_receive(:data).and_return(character_data)
      total, actual = fighter.count_adornments

      total.should eq 4
      actual.should eq 3
    end

    it 'should return valid values for specified slots' do
      scout.should_receive(:data).and_return(character_data)
      total, actual = scout.count_adornments('white')

      total.should eq 2
      actual.should eq 1
    end
  end

  describe '#char_type_name' do
    let(:character) { mock_model(:character) }

    it "should return raid main for char_type 'm'" do
      char_type_name('m').should eq 'Raid Main'
    end

    it "should return raid alternate for char_type 'r'" do
      char_type_name('r').should eq 'Raid Alternate'
    end

    it "should return general alternate for any other char_type" do
      char_type_name('blah blah').should eq 'General Alternate'
    end
  end
end
