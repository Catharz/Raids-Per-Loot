require 'spec_helper'

describe "archetypes/new.html.erb" do
  before(:each) do
    assign(:archetype, stub_model(Archetype,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new archetype form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => archetypes_path, :method => "post" do
      assert_select "input#archetype_name", :name => "archetype[name]"
    end
  end
end
