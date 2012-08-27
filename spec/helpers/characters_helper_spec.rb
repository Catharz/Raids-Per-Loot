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
      it "should be optimal if 55,000" do
        health_rating(55000, 'Fighter').should eq "optimal"
      end
      it "should be minimal if 50,000" do
        health_rating(54999, 'Fighter').should eq "minimal"
        health_rating(50000, 'Fighter').should eq "minimal"
      end
      it "should be unsatisfactory if below 50,000" do
        health_rating(49999, 'Fighter').should eq "unsatisfactory"
      end
    end

    context "Priest" do
      it "should be optimal if 50,000" do
        health_rating(50000, 'Priest').should eq "optimal"
      end
      it "should be minimal if 45,000" do
        health_rating(49999, 'Priest').should eq "minimal"
        health_rating(45000, 'Priest').should eq "minimal"
      end
      it "should be unsatisfactory if below 45,000" do
        health_rating(44999, 'Priest').should eq "unsatisfactory"
      end
    end

    context "Scout" do
      it "should be optimal if 45,000" do
        health_rating(45000, 'Scout').should eq "optimal"
      end
      it "should be minimal if 40,000" do
        health_rating(44999, 'Scout').should eq "minimal"
        health_rating(40000, 'Scout').should eq "minimal"
      end
      it "should be unsatisfactory if below 40,000" do
        health_rating(39999, 'Scout').should eq "unsatisfactory"
      end
    end

    context "Mage" do
      it "should be optimal if 45,000" do
        health_rating(45000, 'Mage').should eq "optimal"
      end
      it "should be minimal if 40,000" do
        health_rating(44999, 'Mage').should eq "minimal"
        health_rating(40000, 'Mage').should eq "minimal"
      end
      it "should be unsatisfactory if below 40,000" do
        health_rating(39999, 'Mage').should eq "unsatisfactory"
      end
    end
  end

  describe "#crit_rating" do
    it "should be optimal if 310.0" do
      crit_rating(310.0).should eq "optimal"
    end

    it "should be minimal if 285.0" do
      crit_rating(309.99).should eq "minimal"
      crit_rating(285.0).should eq "minimal"
    end

    it "should be unsatisfactory if below 285.0" do
      crit_rating(284.99).should eq "unsatisfactory"
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
end
