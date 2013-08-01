require 'spec_helper'
require 'will_paginate/array'
require 'authentication_spec_helper'

describe 'raids/index.html.erb' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
    prog = stub_model(RaidType, name: 'Progression')
    assign(:raids, [
        stub_model(Raid, :raid_date => Date.parse('01/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('02/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('03/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('04/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('05/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('06/01/2012'), raid_type: prog),
        stub_model(Raid, :raid_date => Date.parse('07/01/2012'), raid_type: prog)
    ].paginate(:page => 1, :per_page => 5))
  end

  it 'renders a list of raids' do
    render

    assert_select 'tr>td', text: 'Progression'
    assert_select 'tr>td', text: '2012-01-01'
  end
end
