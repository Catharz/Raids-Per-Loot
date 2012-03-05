require 'spec_helper'

describe "raids/show.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)
    @raid = assign(:raid, stub_model(Raid, :raid_date => Date.parse("01/01/2011")))
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/2011-01-01/)
  end
end
