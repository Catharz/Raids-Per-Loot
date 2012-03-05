require 'spec_helper'
require 'will_paginate/array'

describe "raids/index.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)
    assign(:raids, [
        stub_model(Raid, :raid_date => Date.parse("01/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("02/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("03/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("04/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("05/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("06/01/2012")),
        stub_model(Raid, :raid_date => Date.parse("07/01/2012"))
    ].paginate(:page => 1, :per_page => 5))
  end

  it "renders a list of raids" do
    render

    assert_select "tr>td", :text => "2012-01-01".to_s
  end
end
