require 'spec_helper'

describe 'archetypes/index.html.erb' do
  before(:each) do
    assign(:archetypes, [
        stub_model(Archetype, name: 'Scout'),
        stub_model(Archetype, name: 'Fighter'),
        stub_model(Archetype, name: 'Mage'),
        stub_model(Archetype, name: 'Priest')
    ])
  end

  it 'renders a list of archetypes, including root archetypes' do
    render
    assert_select 'tr>td', text: 'Scout'.to_s, count: 2
    assert_select 'tr>td', text: 'Fighter'.to_s, count: 2
    assert_select 'tr>td', text: 'Mage'.to_s, count: 2
    assert_select 'tr>td', text: 'Priest'.to_s, count: 2
  end
end
