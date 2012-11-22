require 'spec_helper'
include CharactersHelper

describe CharactersHelper do
  let(:character_data) { {
      'equipmentslot_list' => [
          'item' => {
              'adornment_list' => [
                  {'color' => 'white', 'id' => 3456},
                  {'color' => 'white', 'id' => nil},
                  {'color' => 'yellow', 'id' => 1234},
                  {'color' => 'red', 'id' => 5678}
              ]}
      ]}
  }
  describe "#health_rating" do
    context "Fighter" do
      it "should be optimal if 65,000" do
        health_rating(65000, 'Fighter').should eq "optimal"
      end
      it "should be minimal if 60,000" do
        health_rating(64999, 'Fighter').should eq "minimal"
        health_rating(60000, 'Fighter').should eq "minimal"
      end
      it "should be unsatisfactory if below 60,000" do
        health_rating(59999, 'Fighter').should eq "unsatisfactory"
      end
    end

    context "Priest" do
      it "should be optimal if 50,000" do
        health_rating(60000, 'Priest').should eq "optimal"
      end
      it "should be minimal if 55,000" do
        health_rating(59999, 'Priest').should eq "minimal"
        health_rating(55000, 'Priest').should eq "minimal"
      end
      it "should be unsatisfactory if below 55,000" do
        health_rating(54999, 'Priest').should eq "unsatisfactory"
      end
    end

    context "Scout" do
      it "should be optimal if 55,000" do
        health_rating(55000, 'Scout').should eq "optimal"
      end
      it "should be minimal if 50,000" do
        health_rating(54999, 'Scout').should eq "minimal"
        health_rating(50000, 'Scout').should eq "minimal"
      end
      it "should be unsatisfactory if below 50,000" do
        health_rating(49999, 'Scout').should eq "unsatisfactory"
      end
    end

    context "Mage" do
      it "should be optimal if 55,000" do
        health_rating(55000, 'Mage').should eq "optimal"
      end
      it "should be minimal if 50,000" do
        health_rating(54999, 'Mage').should eq "minimal"
        health_rating(50000, 'Mage').should eq "minimal"
      end
      it "should be unsatisfactory if below 50,000" do
        health_rating(49999, 'Mage').should eq "unsatisfactory"
      end
    end
  end

  describe "#crit_rating" do
    it "should be optimal if 420.0" do
      crit_rating(420.0).should eq "optimal"
    end

    it "should be minimal if 350.0" do
      crit_rating(419.99).should eq "minimal"
      crit_rating(350.0).should eq "minimal"
    end

    it "should be unsatisfactory if below 350.0" do
      crit_rating(349.99).should eq "unsatisfactory"
    end
  end

  describe "#adornment_rating" do
    it "should be optimal if 75.0" do
      adornment_rating(75.0).should eq "optimal"
    end

    it "should be minimal if 50.0" do
      adornment_rating(74.99).should eq "minimal"
      adornment_rating(50.0).should eq "minimal"
    end

    it "should be unsatisfactory if below 50.0" do
      adornment_rating(49.99).should eq "unsatisfactory"
    end
  end

  describe "#adornment_stats" do
    context "should return valid equations" do
      it "for all slots when colour is unspecified" do
        adornment_stats(character_data).should eq "3 / 4"
      end
      it "for the specified colour" do
        adornment_stats(character_data, 'white').should eq "1 / 2"
      end
    end
  end

  describe "#adornment_pct" do
    it "should calculate correctly for all adornments" do
      adornment_pct(character_data).should eq 75.00
    end

    it "should calculate correctly for specific adornments" do
      adornment_pct(character_data, 'white').should eq 50.00
    end
  end

  describe "#count_adornments" do
    it "should return valid values for all slots" do
      total, actual = count_adornments(character_data)

      total.should eq 4
      actual.should eq 3
    end

    it "should return valid values for specified slots" do
      total, actual = count_adornments(character_data, 'white')

      total.should eq 2
      actual.should eq 1
    end
  end

  describe "#char_type_name" do
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
