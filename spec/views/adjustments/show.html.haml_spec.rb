require 'spec_helper'

describe "adjustments/show" do
  before(:each) do
    @adjustment = assign(:adjustment, stub_model(Adjustment,
      :adjustment_type => "Adjustment Type",
      :amount => 1,
      :reason => "MyText",
      :name => "Dino",
      :adjustable_type => "Character"
    ))
  end

  it "renders the headings" do
    render

    rendered.should match(/Adjustment type:/)
    rendered.should match(/Amount:/)
    rendered.should match(/Reason:/)
    rendered.should match(/Character:/)
  end

  it "renders the data" do
    render

    rendered.should match(/Adjustment Type/)
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/Dino/)
  end
end
