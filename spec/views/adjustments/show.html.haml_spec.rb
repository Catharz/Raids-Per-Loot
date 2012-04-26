require 'spec_helper'

describe "adjustments/show" do
  before(:each) do
    @adjustment = assign(:adjustment, stub_model(Adjustment,
      :adjustment_type => "Adjustment Type",
      :amount => 1,
      :reason => "MyText",
      :loot_type_id => 1,
      :adjustable_id => 1,
      :adjustable_type => "Adjustable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Adjustment Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Adjustable Type/)
  end
end
