require 'spec_helper'

describe 'players/new' do
  before(:each) do
    assign(:player, stub_model(Player, name: 'MyString').as_new_record)
  end

  it 'renders new player form' do
    render

    assert_select 'form', action: players_path, method: 'post' do
      assert_select 'input#player_name', name: 'player[name]'
    end
  end
end
