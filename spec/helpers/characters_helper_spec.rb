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
      fighter.stub(:data).and_return(character_data)
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('optimal')

      fighter.overall_rating
    end

    it 'is unsatisfactory if any of the ratings are unsatisfactory' do
      fighter.stub(:data).and_return(character_data)
      fighter.should_receive(:health_rating).and_return('unsatisfactory')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('minimal')

      fighter.overall_rating.should eq 'unsatisfactory'
    end

    it 'is minimal if the worst rating is minimal' do
      fighter.stub(:data).and_return(character_data)
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('minimal')

      fighter.overall_rating.should eq 'minimal'
    end

    it 'is only optimal if all the ratings are optimal' do
      fighter.stub(:data).and_return(character_data)
      fighter.should_receive(:health_rating).and_return('optimal')
      fighter.should_receive(:crit_rating).and_return('optimal')
      fighter.should_receive(:adornment_rating).and_return('optimal')

      fighter.overall_rating.should eq 'optimal'
    end
  end

  describe '#health_rating' do
    let(:health_requirements) {
      {
          fighter => {min: 500000, opt: 550000},
          priest => {min: 300000, opt: 350000},
          scout => {min: 300000, opt: 350000},
          mage => {min: 300000, opt: 350000}
      }
    }
    context 'returns unsatisfactory' do
      it 'if the minimum is not met' do
        health_requirements.each_pair do |k,v|
          k.stub(:health).and_return(v[:min] - 1)
          k.health_rating.should eq 'unsatisfactory'
        end
      end
    end
    context 'returns minimal' do
      it 'if the minimum is just met' do
        health_requirements.each_pair do |k,v|
          k.stub(:health).and_return(v[:min])
          k.health_rating.should eq 'minimal'
        end
      end
      it 'if just below optimal' do
        health_requirements.each_pair do |k,v|
          k.stub(:health).and_return(v[:opt] - 1)
          k.health_rating.should eq 'minimal'
        end
      end
    end
    context 'returns optimal' do
      it 'if optimal is just met' do
        health_requirements.each_pair do |k,v|
          k.stub(:health).and_return(v[:opt])
          k.health_rating.should eq 'optimal'
        end
      end
    end
  end

  describe '#crit_rating' do
    it 'should be optimal if 600.0' do
      fighter.should_receive(:critical_chance).and_return(600.0)
      fighter.crit_rating.should eq 'optimal'
    end

    it 'should be minimal if between 580.0 and 600.0' do
      priest.should_receive(:critical_chance).twice.and_return(599.99)
      priest.crit_rating.should eq 'minimal'

      scout.should_receive(:critical_chance).twice.and_return(580.00)
      scout.crit_rating.should eq 'minimal'
    end

    it 'should be unsatisfactory if below 580.0' do
      mage.should_receive(:critical_chance).twice.and_return(579.99)
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
