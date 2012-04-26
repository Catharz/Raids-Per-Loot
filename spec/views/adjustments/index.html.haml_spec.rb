require 'spec_helper'

describe "adjustments/index" do
  before(:each) do
    assign(:adjustments, [
      stub_model(Adjustment,
        :adjustment_type => "Raids",
        :amount => 5,
        :reason => "Ok Switch",
        :loot_type_id => 3,
        :adjustable_id => 1,
        :adjustable_type => "Character"
      ),
      stub_model(Adjustment,
        :adjustment_type => "Armour",
        :amount => 10,
        :reason => "Great Switch",
        :loot_type_id => 4,
        :adjustable_id => 1,
        :adjustable_type => "Player"
      )
    ])
  end

  it "renders a list of adjustments" do
    render

    assert_select "tr>td", :text => "Raids".to_s, :count => 1

    # Adjustment Amount
    assert_select "tr>td", :text => 5.to_s, :count => 1
    assert_select "tr>td", :text => 10.to_s, :count => 1

    # Reasons
    assert_select "tr>td", :text => "Ok Switch".to_s, :count => 1
    assert_select "tr>td", :text => "Great Switch".to_s, :count => 1

    # Loot Types
    assert_select "tr>td", :text => 3.to_s, :count => 1
    assert_select "tr>td", :text => 4.to_s, :count => 1

    # Adjustable Id
    assert_select "tr>td", :text => 1.to_s, :count => 2

    # Adjustable Types
    assert_select "tr>td", :text => "Character".to_s, :count => 1
    assert_select "tr>td", :text => "Player".to_s, :count => 1
  end
end
