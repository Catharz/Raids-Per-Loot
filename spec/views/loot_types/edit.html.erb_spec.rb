require 'spec_helper'

describe "loot_types/edit.html.erb" do
  before(:each) do
    @loot_type = assign(:loot_type, stub_model(LootType,
      :name => "MyString"
    ))
  end

  it "renders the edit loot_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => loot_types_path(@loot_type), :method => "post" do
      assert_select "input#loot_type_name", :name => "loot_type[name]"
    end
  end
end
