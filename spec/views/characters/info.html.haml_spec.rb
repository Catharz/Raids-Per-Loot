require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'

describe "characters/info.html.haml" do
  include AttendanceSpecHelper
  include CharacterSpecHelper

  it "should show the characters name" do
    character_list = setup_characters(%w{Fighter Priest})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    external_data = mock_model(ExternalData, :retrievable_id => character.id, :retrievable_type => "Character", :data => {})
    character.should_receive(:external_data).at_least(:twice).and_return(external_data)

    render

    rendered.should have_content 'Fighter'
  end

  it "should show the number of instances" do
    character_list = setup_characters(%w{Scout Mage})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    external_data = mock_model(ExternalData, :retrievable_id => character.id, :retrievable_type => "Character", :data => {})
    character.should_receive(:external_data).at_least(:twice).and_return(external_data)

    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of raids" do
    character_list = setup_characters(%w{Scout Mage})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    external_data = mock_model(ExternalData, :retrievable_id => character.id, :retrievable_type => "Character", :data => {})
    character.should_receive(:external_data).at_least(:twice).and_return(external_data)

    render

    rendered.should have_content 'Raids: 2'
  end
end