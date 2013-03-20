require 'spec_helper'

describe 'characters/index.html.haml' do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    main_rank = stub_model(Rank, name: 'Main')
    scout = stub_model(Archetype, name: 'Scout')
    fighter = stub_model(Archetype, name: 'Fighter')
    priest = stub_model(Archetype, name: 'Priest')
    mage = stub_model(Archetype, name: 'Mage')

    player = stub_model(Player,
                        name: 'This Player',
                        rank_id: main_rank.id)

    fighter_char = stub_model(Character,
                              name: 'Fighter Main',
                              player: player,
                              archetype: fighter)
    scout_raid_alt = stub_model(Character,
                                name: 'Scout Raid Alt',
                                player: player,
                                archetype: scout)
    assign(:ranks, [main_rank])
    assign(:archetypes, [fighter, priest, mage, scout])
    assign(:characters, [fighter_char, scout_raid_alt])
    assign(:players, [player])
  end

  context 'links' do
    it 'should have show links for each character' do
      render

      assert_select 'td', text: 'Fighter Main', count: 1
      assert_select 'td', text: 'Scout Raid Alt', count: 1
    end

    it 'should have an Edit link for each character' do
      render

      assert_select 'td', :text => 'Edit'.to_s, :count => 2
    end

    it 'should have an Update link for each character' do
      render

      assert_select 'td', :text => 'Update'.to_s, :count => 2
    end

    it 'should have a Destroy link for each character' do
      render

      assert_select 'td', :text => 'Destroy'.to_s, :count => 2
    end
  end

  it 'should list all tabs' do
    render

    rendered.should have_content 'Raid Mains'
    rendered.should have_content 'Raid Alts'
    rendered.should have_content 'General Alts'
    rendered.should have_content 'All'
  end

  it 'should list all characters' do
    render

    rendered.should have_content 'Fighter Main'
    rendered.should have_content 'Scout Raid Alt'
  end
end