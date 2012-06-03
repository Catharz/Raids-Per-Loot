require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'

describe "characters/show.html.haml" do
  include AttendanceSpecHelper
  include CharacterSpecHelper
  fixtures :users

  before(:each) do
    login_as users(:quentin)
  end

  it "should show the number of instances" do
    character_list = setup_characters(%w{Freddy})
    setup_raids(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    assign(:drop_list, [])
    assign(:instance_list, character.instances)
    assign(:adjustment_list, [])
    assign(:character_types, [])

    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of raids" do
    character_list = setup_characters(%w{Julie})
    setup_raids(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)
    assign(:drop_list, [])
    assign(:instance_list, character.instances)
    assign(:adjustment_list, [])
    assign(:character_types, [])

    render

    rendered.should have_content 'Raids: 2'
  end
end