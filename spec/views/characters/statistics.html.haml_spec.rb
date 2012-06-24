require 'spec_helper'

describe "characters/statistics.html.haml" do
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
  end
end