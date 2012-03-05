require 'spec_helper'

describe "players/index.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)

    scout = stub_model(Archetype, :name => "Scout")
    fighter = stub_model(Archetype, :name => "Fighter")
    scout_player = stub_model(Player,
                       :name => "Scout 1",
                       :archetype_id => scout.id)
    fighter_player = stub_model(Player,
                       :name => "Fighter 1",
                       :archetype_id => fighter.id)
    assign(:player_archetypes, {"Scout" => [scout_player], "Fighter" => [fighter_player]})
    assign(:players, [scout_player, fighter_player])
  end

  it "renders a list of players" do
    render

    assert_select "h3", :text => "Scouts".to_s, :count => 1
    assert_select "tr>td", :text => "Scout 1".to_s, :count => 1
    assert_select "h3", :text => "Fighters".to_s, :count => 1
    assert_select "tr>td", :text => "Fighter 1".to_s, :count => 1
  end
end
