require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'
require 'drop_spec_helper'

describe "characters/show.html.haml" do
  include AttendanceSpecHelper, CharacterSpecHelper, DropSpecHelper

  let(:character) { mock_model(Character,
                               :name => "Julie",
                               :archetype => mock_model(Archetype, :name => "Mage"),
                               :char_type => "m",
                               :raids => [],
                               :instances => [],
                               :drops => [],
                               :adjustments => []) }

  before(:each) do
    character_list = setup_characters(%w{Julie})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)

    drop_list = create_drops(character, "Armour" => 2, "Weapon" => 3, "Jewellery" => 1)
    character.stub!(:drops).and_return(drop_list)
    character.stub!(:adjustments).and_return([])
    character.stub!(:armour_rate).and_return(2.0)
    character.stub!(:weapon_rate).and_return(3.6)
    character.stub!(:jewellery_rate).and_return(6.9)

    assign(:drop_list, character.drops)
    assign(:instance_list, character.instances)
    assign(:adjustment_list, [])
    assign(:character_types, [])
  end

  it "should show the characters name" do
    render

    rendered.should contain("Name: Julie")
  end

  it "should show the number of raids" do
    render

    rendered.should have_content 'Raids: 2'
  end

  it "should show the number of instances" do
    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of drops" do
    render

    rendered.should contain("Drops: 6")
  end

  it "should show the armour rate" do
    render

    rendered.should contain("Armour Rate: 2.0")
  end

  it "should show the weapon rate" do
    render

    rendered.should contain("Weapon Rate: 3.6")
  end

  it "should show the jewellery rate" do
    render

    rendered.should contain("Jewellery Rate: 6.9")
  end
end