require 'spec_helper'

describe "raids/index.html.erb" do
  before(:each) do
    assign(:raids, [
      stub_model(Raid),
      stub_model(Raid)
    ])
  end

  it "renders a list of raids" do
    render
  end
end
