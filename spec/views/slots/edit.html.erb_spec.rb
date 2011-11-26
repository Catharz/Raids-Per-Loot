require 'spec_helper'

describe "slots/edit.html.erb" do
  before(:each) do
    @slot = assign(:slot, stub_model(Slot,
      :name => "MyString"
    ))
  end

  it "renders the edit slot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => slots_path(@slot), :method => "post" do
      assert_select "input#slot_name", :name => "slot[name]"
    end
  end
end
