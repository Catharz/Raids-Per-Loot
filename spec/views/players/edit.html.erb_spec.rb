require 'spec_helper'

describe "players/edit.html.erb" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :name => "MyString"
    ))
  end

  it "renders the edit player form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => players_path(@player), :method => "post" do
      assert_select "input#player_name", :name => "player[name]"
    end
  end
end
