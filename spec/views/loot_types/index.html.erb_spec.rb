require 'spec_helper'

describe 'loot_types/index.html.erb' do
  before(:each) do
    assign(:loot_types, [
      stub_model(LootType,
        name: 'Name'
      ),
      stub_model(LootType,
        name: 'Name'
      )
    ])
  end

  it 'renders a list of loot_types' do
    render

    assert_select 'tr>td', text: 'Name'.to_s, count: 2
  end
end
