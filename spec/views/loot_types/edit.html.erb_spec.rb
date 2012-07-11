require 'spec_helper'

describe "loot_types/edit.html.erb" do
  before(:each) do
    @loot_type = assign(:loot_type, stub_model(LootType,
      :name => "MyString", :default_loot_method => "n"
    ))
  end

  it "renders the edit loot_type form" do
    render

    assert_select "form", :action => loot_types_path(@loot_type), :method => "post" do |form|

      form.should have_selector("input", :type => "submit")
      form.should have_selector("input", :name => "loot_type[name]")
      form.should have_selector("input", :name => "loot_type[default_loot_method]", :type => "radio", :id => "need")
      form.should have_selector("input", :name => "loot_type[default_loot_method]", :type => "radio", :id => "random")
      form.should have_selector("input", :name => "loot_type[default_loot_method]", :type => "radio", :id => "bid")
      form.should have_selector("input", :name => "loot_type[default_loot_method]", :type => "radio", :id => "trash")
    end
  end
end
