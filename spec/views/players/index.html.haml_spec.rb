require 'spec_helper'
require 'authentication_spec_helper'

describe 'players/index.html.haml' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin

    main_rank = stub_model(Rank, :name => 'Main')
    scout_player = stub_model(Player, :name => 'Scout Main', :rank_id => main_rank.id)
    fighter_player = stub_model(Player, :name => 'Fighter Main', :rank_id => main_rank.id)
    priest_player = stub_model(Player, :name => 'Priest Alternate', :rank_id => main_rank.id)
    mage_player = stub_model(Player, :name => 'Mage Alternate', :rank_id => main_rank.id)

    assign(:players, [scout_player, fighter_player, priest_player, mage_player])
    assign(:ranks, [main_rank])
  end

  it "should list main character names" do
    render

    assert_select 'tr>td', :text => 'Scout Main'.to_s, :count => 1
    assert_select 'tr>td', :text => 'Fighter Main'.to_s, :count => 1
  end
end
