require 'spec_helper'
require 'attendance_spec_helper'

describe 'characters/info.html.haml' do
  before(:each) do
    character = assign(:character, FactoryGirl.create(:character, name: 'Fighter'))

    character.should_receive(:player_raids_count).and_return(2)
    character.should_receive(:raids_count).and_return(1)
    character.should_receive(:instances_count).and_return(6)
    character.should_receive(:health).and_return(50000)
    character.should_receive(:power).and_return(45000)
    character.should_receive(:critical_chance).and_return(298.02)
    character.should_receive(:potency).and_return(220.02)
    character.should_receive(:crit_bonus).and_return(150.01)
    character.should_receive(:alternate_advancement_points).and_return(320)
  end

  it 'should show the characters name' do
    render

    rendered.should have_content 'Fighter'
  end

  it 'should show the number of instances' do
    render

    rendered.should have_content 'Instances: 6'
  end

  it 'should show the number of player raids' do
    render

    rendered.should have_content 'Raids (Player): 2'
  end

  it 'should show the number of character raids' do
    render

    rendered.should have_content 'Raids (Character): 1'
  end

  it 'should show the characters health' do
    render

    rendered.should have_content 'Health: 50000'
  end

  it 'should show the characters power' do
    render

    rendered.should have_content 'Power: 45000'
  end

  it 'should show the characters critical chance' do
    render

    rendered.should have_content 'Critical Chance: 298.02'
  end

  it 'should show the characters critical bonus' do
    render

    rendered.should have_content 'Critical Bonus: 150.01'
  end

  it 'should show the characters potency' do
    render

    rendered.should have_content 'Potency: 220.02'
  end
end