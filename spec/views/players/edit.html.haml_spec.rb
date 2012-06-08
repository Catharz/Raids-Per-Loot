require 'spec_helper'

describe "players/edit.html.haml" do
  fixtures :users

  before(:each) do
    login_as :quentin
    @player = assign(:player, stub_model(Player,
      :name => "MyString"
    ))
    archetype = stub_model(Archetype, :name => 'Archetype')
    char1 = stub_model(Character, :name => 'Character 1', :player => @player, :archetype => archetype)
    char2 = stub_model(Character, :name => 'Character 2', :player => @player, :archetype => archetype)
    @player.characters << [char1, char2]
  end

  it "renders the edit player form" do
    render

    assert_select "form", :action => players_path(@player), :method => "post" do
      assert_select "input#player_name", :name => "player[name]"
    end
  end

  it "should list all the players characters" do
    render

    assert_select "form" do
      assert_select "input#player_characters_attributes_0_name",
                    :name => "player[characters_attributes][0][name]",
                    :value => "Character 1"
      assert_select "input#player_characters_attributes_1_name",
                    :name => "player[characters_attributes][1][name]",
                    :value => "Character 2"
    end
  end
end
