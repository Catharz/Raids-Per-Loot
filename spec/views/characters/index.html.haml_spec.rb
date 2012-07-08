require 'spec_helper'

describe "characters/index.html.haml" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    main_rank = stub_model(Rank, :name => "Main")
    scout = stub_model(Archetype, :name => "Scout")
    fighter = stub_model(Archetype, :name => "Fighter")
    priest = stub_model(Archetype, :name => "Priest")
    mage = stub_model(Archetype, :name => "Mage")

    player = stub_model(Player,
                        :name => "This Player",
                        :rank_id => main_rank.id)

    fighter_char = stub_model(Character,
                              :name => "Fighter Main",
                              :player => player,
                              :archetype => fighter)
    scout_raid_alt = stub_model(Character,
                                :name => "Scout Raid Alt",
                                :player => player,
                                :archetype => scout)
    assign(:ranks, [main_rank])
    assign(:archetypes, [fighter, priest, mage, scout])
    characters = mock(ActiveRecord::Relation)
    characters.stub_chain(:where).with(:char_type => 'm').and_return([fighter_char])
    characters.stub_chain(:where).with(:char_type => 'r').and_return([scout_raid_alt])
    characters.stub_chain(:where).with(:char_type => 'g').and_return([])
    assign(:characters, characters)
    assign(:players, [player])
  end

  it "should list all characters" do
    render

    rendered.should have_content "Fighter Main"
    rendered.should have_content "Scout Raid Alt"
  end
end