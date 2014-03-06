require 'spec_helper'

describe 'mobs/edit.html.erb' do
  before(:each) do
    @mob = assign(:mob, stub_model(Mob,
      name: 'MyString',
      strategy: 'MyText'
    ))
  end

  it 'renders the edit mob form' do
    render

    assert_select 'form', action: mobs_path(@mob), method: 'post' do
      assert_select 'input#mob_name', name: 'mob[name]'
      assert_select 'textarea#mob_strategy', name: 'mob[strategy]'
    end
  end
end
