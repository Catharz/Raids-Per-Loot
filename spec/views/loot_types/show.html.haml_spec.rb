require 'spec_helper'

describe 'loot_types/show.html.erb' do
  before(:each) do
    @loot_type = assign(:loot_type, stub_model(LootType,
      name: 'Name'
    ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Name/)
  end
end
