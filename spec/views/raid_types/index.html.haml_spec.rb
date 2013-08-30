require 'spec_helper'

describe 'raid_types/index' do
  before(:each) do
    assign(:raid_types, [
      stub_model(RaidType,
        name: 'Prog Raid',
        raid_counted: true,
        raid_points: 1.0,
        loot_counted: true,
        loot_cost: 2.0
      ),
      stub_model(RaidType,
        name: 'Plat Raid',
        raid_counted: true,
        raid_points: 0.5,
        loot_counted: false,
        loot_cost: 0.0
      )
    ])
  end

  it 'renders the headings' do
    render

    assert_select 'tr>th', text: 'Name', count: 1
    assert_select 'tr>th', text: 'Raid counted', count: 1
    assert_select 'tr>th', text: 'Raid points', count: 1
    assert_select 'tr>th', text: 'Loot counted', count: 1
    assert_select 'tr>th', text: 'Loot cost', count: 1
  end

  it 'renders a list of raid types' do
    render

    assert_select 'tr>td', text: 'Prog Raid'.to_s, count: 1
    assert_select 'tr>td', text: true.to_s, count: 3
    assert_select 'tr>td', text: 1.0.to_s, count: 1
    assert_select 'tr>td', text: 2.0.to_s, count: 1

    assert_select 'tr>td', text: 'Plat Raid'.to_s, count: 1
    assert_select 'tr>td', text: 0.5.to_s, count: 1
    assert_select 'tr>td', text: false.to_s, count: 1
    assert_select 'tr>td', text: 0.0.to_s, count: 1
  end
end
