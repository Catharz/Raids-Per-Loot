require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'

describe "characters/info.html.haml" do
  include AttendanceSpecHelper
  include CharacterSpecHelper

  before(:each) do
    character_list = setup_characters(%w{Fighter Priest Mage Scout})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    external_data = mock_model(ExternalData,
                               :retrievable_id => character.id,
                               :retrievable_type => "Character",
                               :data => {
                                   :stats => {
                                       :health => {:max => 50000},
                                       :power => {:max => 45000},
                                       :combat => {:critchance => 298.02,
                                                   :basemodifier => 220.02,
                                                   :critbonus => 150.01}}
                               })
    character.should_receive(:external_data).at_least(:once).and_return(external_data)
  end

  it "should show the characters name" do
    render

    rendered.should have_content 'Fighter'
  end

  it "should show the number of instances" do
    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of raids" do
    render

    rendered.should have_content 'Raids: 2'
  end

  it "should show the characters health" do
    render

    rendered.should have_content "Health: 50000"
  end

  it "should show the characters power" do
    render

    rendered.should have_content "Power: 45000"
  end

  it "should show the characters critical chance" do
    render

    rendered.should have_content "Critical Chance: 298.02"
  end

  it "should show the characters critical bonus" do
    render

    rendered.should have_content "Critical Bonus: 150.01"
  end

  it "should show the characters potency" do
    render

    rendered.should have_content "Potency: 220.02"
  end
end