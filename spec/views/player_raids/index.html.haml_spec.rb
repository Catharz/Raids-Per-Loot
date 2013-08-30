require 'spec_helper'
require 'authentication_spec_helper'

describe 'player_raids/index.html.haml' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin

    pr1 = stub_model(PlayerRaid,
                     player_name: 'Fred',
                     raid_description: '2013-02-28 (Normal)',
                     attended: true,
                     punctual: false,
                     status: 'a')
    pr2 = stub_model(PlayerRaid,
                     player_name: 'Barney',
                     raid_description: '2013-02-28 (Normal)',
                     attended: true,
                     punctual: false,
                     status: 'b')
    assign(:player_raids, [pr1, pr2])
  end

  it 'should list player names' do
    render

    assert_select 'tr>td', text: 'Fred', count: 1
    assert_select 'tr>td', text: 'Barney', count: 1
  end

  it 'should list raids' do
    render

    assert_select 'tr>td', text: '2013-02-28 (Normal)', count: 2
  end

  it 'should list the attendance details' do
    render

    assert_select 'tr>td', text: 'false', count: 2
    assert_select 'tr>td', text: 'true', count: 2
  end

  it 'should list the status' do
    render

    assert_select 'tr>td', text: 'Attended', count: 1
    assert_select 'tr>td', text: 'Benched', count: 1
  end
end
