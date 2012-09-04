require 'spec_helper'

describe "adjustments/index" do
  before(:each) do
    assign(:adjustments, [
      stub_model(Adjustment,
        :adjustment_type => "Raids",
        :amount => 5,
        :reason => "Ok Switch",
        :adjusted_name => "Fred",
        :adjustable_type => "Character"
      ),
      stub_model(Adjustment,
        :adjustment_type => "Armour",
        :amount => 10,
        :reason => "Great Switch",
        :adjusted_name => "Barney",
        :adjustable_type => "Player"
      )
    ])
  end

  it "renders a list of adjustments" do
    render

    assert_select "tr>td", :text => "Armour".to_s, :count => 1
    assert_select "tr>td", :text => "Raids".to_s, :count => 1

    # Adjustment Amount
    assert_select "tr>td", :text => 5.to_s, :count => 1
    assert_select "tr>td", :text => 10.to_s, :count => 1

    # Reasons
    assert_select "tr>td", :text => "Ok Switch".to_s, :count => 1
    assert_select "tr>td", :text => "Great Switch".to_s, :count => 1

    # Who was adjusted
    assert_select "tr>td", :text => "Fred", :count => 1
    assert_select "tr>td", :text => "Barney", :count => 1

    # Adjustable Types
    assert_select "tr>td", :text => "Character".to_s, :count => 1
    assert_select "tr>td", :text => "Player".to_s, :count => 1
  end
end
