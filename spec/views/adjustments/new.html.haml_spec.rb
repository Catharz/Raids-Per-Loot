require 'spec_helper'

describe "adjustments/new" do
  before(:each) do
    assign(:adjustment, stub_model(Adjustment,
      :adjustment_type => "MyString",
      :amount => 1,
      :reason => "MyText",
      :loot_type_id => 1,
      :adjustable_id => 1,
      :adjustable_type => "MyString"
    ).as_new_record)
  end

  it "renders new adjustment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => adjustments_path, :method => "post" do
      assert_select "input#adjustment_adjustment_type", :name => "adjustment[adjustment_type]"
      assert_select "input#adjustment_amount", :name => "adjustment[amount]"
      assert_select "textarea#adjustment_reason", :name => "adjustment[reason]"
      assert_select "input#adjustment_loot_type_id", :name => "adjustment[loot_type_id]"
      assert_select "input#adjustment_adjustable_id", :name => "adjustment[adjustable_id]"
      assert_select "input#adjustment_adjustable_type", :name => "adjustment[adjustable_type]"
    end
  end
end
