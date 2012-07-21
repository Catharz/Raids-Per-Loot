require 'spec_helper'

describe "characters/statistics.html.haml" do
  it "should render the tabs" do
    assign(:characters, [])
    render

    rendered.should contain "Raid Mains"
    rendered.should contain "Raid Alts"
    rendered.should contain "General Alts"
    rendered.should contain "All"
  end

  it "should render all the headings" do
    assign(:characters, [])
    render

    rendered.should contain "Name"
    rendered.should contain "Class"
    rendered.should contain "Level"
    rendered.should contain "AAs"
    rendered.should contain "Health"
    rendered.should contain "Power"
    rendered.should contain "Crit"
    rendered.should contain "Crit Bonus"
    rendered.should contain "Potency"
    rendered.should contain "Adornments"
    rendered.should contain "White"
    rendered.should contain "Yellow"
    rendered.should contain "Red"
  end
end