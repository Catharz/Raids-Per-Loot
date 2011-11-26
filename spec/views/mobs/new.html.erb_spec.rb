require 'spec_helper'

describe "mobs/new.html.erb" do
  before(:each) do
    assign(:mob, stub_model(Mob,
      :name => "MyString",
      :strategy => "MyText"
    ).as_new_record)
  end

  it "renders new mob form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mobs_path, :method => "post" do
      assert_select "input#mob_name", :name => "mob[name]"
      assert_select "textarea#mob_strategy", :name => "mob[strategy]"
    end
  end
end
