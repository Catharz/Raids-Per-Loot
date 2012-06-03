require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'

describe "characters/info.html.haml" do
  include AttendanceSpecHelper
  include CharacterSpecHelper

  it "should show the characters name" do
    character_list = setup_characters(%w{Fighter Priest})
    assign(:character, character_list.first)

    render

    rendered.should have_content 'Fighter'
  end

  it "should show the number of instances" do
    character_list = setup_characters(%w{Scout Mage})
    setup_raids(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    assign(:character, character_list.first)

    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of raids" do
    character_list = setup_characters(%w{Scout Mage})
    setup_raids(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    assign(:character, character_list.first)

    render

    rendered.should have_content 'Raids: 2'
  end

end