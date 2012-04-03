require 'spec_helper'

describe "drops/new.html.erb" do
  before(:each) do
    assign(:drop, stub_model(Drop,
      :zone_name => "MyString",
      :mob_name => "MyString",
      :character_name => "MyString",
      :item_name => "MyString",
      :eq2_item_id => "MyString"
    ).as_new_record)
  end

  it "renders new drop form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => drops_path, :method => "post" do
      assert_select "input#drop_zone_name", :name => "drop[zone_name]"
      assert_select "input#drop_mob_name", :name => "drop[mob_name]"
      assert_select "input#drop_character_name", :name => "drop[character_name]"
      assert_select "input#drop_item_name", :name => "drop[item_name]"
      assert_select "input#drop_eq2_item_id", :name => "drop[eq2_item_id]"
    end
  end
end
