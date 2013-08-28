require 'spec_helper'
require 'will_paginate/array'
require 'authentication_spec_helper'

describe 'raids/index.html.erb' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
    prog = stub_model(RaidType, name: 'Progression')
    raids = Array.new(7) { |n|
      stub_model(Raid,
                 raid_date: Date.parse('01/01/2012') + n.days,
                 raid_type: prog)
    }
    assign(:raids, raids.paginate(:page => 1, :per_page => 5))
  end

  it 'renders a paginated list of raids' do
    render

    assert_select 'tr>td', text: 'Progression', count: 5
    assert_select 'tr>td', text: '2012-01-01', count: 1
  end
end
