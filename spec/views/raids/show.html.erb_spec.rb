require 'spec_helper'

describe "raids/show.html.erb" do
  before(:each) do
    @raid = assign(:raid, stub_model(Raid))
  end

  it "renders attributes in <p>" do
    render
  end
end
