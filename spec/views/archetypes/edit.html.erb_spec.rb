require 'spec_helper'

describe "archetypes/edit.html.erb" do
  before(:each) do
    @archetype = assign(:archetype, stub_model(Archetype,
      :name => "MyString"
    ))
  end

  it "renders the edit archetype form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => archetypes_path(@archetype), :method => "post" do
      assert_select "input#archetype_name", :name => "archetype[name]"
    end
  end
end
