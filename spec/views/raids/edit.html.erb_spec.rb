require 'spec_helper'

describe "raids/edit.html.erb" do
  before(:each) do
    prog = stub_model(RaidType, name: 'Progression')
    @raid = assign(:raid, stub_model(Raid, raid_date: Date.parse("01/01/2012"), raid_type: prog))
  end

  it "renders the edit raid form" do
    render

    assert_select "form", :action => raids_path(@raid), :method => "post" do
    end
  end
end
