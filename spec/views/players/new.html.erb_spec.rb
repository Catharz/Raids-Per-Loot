require 'spec_helper'

describe "players/new.html.erb" do
  before(:each) do
    assign(:player, stub_model(Player, :name => "MyString").as_new_record)
  end

  it "renders new player form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => players_path, :method => "post" do
      assert_select "input#player_name", :name => "player[name]"
    end
  end

  it "should render an empty character slot" do
    render

    assert_select "form" do
      assert_select "input#player_characters_attributes_0_name",
                    :name => "player[characters_attributes][0][name]",
                    :value => ""
    end
  end
end
