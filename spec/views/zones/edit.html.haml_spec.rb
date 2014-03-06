require 'spec_helper'

describe 'zones/edit.html.erb' do
  before(:each) do
    @zone = assign(:zone, stub_model(Zone,
      name: 'Zone 1'
    ))
  end

  it 'renders the edit zone form' do
    render

    assert_select 'form', action: zones_path(@zone), method: 'post' do
      assert_select 'input#zone_name', name: 'zone[name]'
      assert_select 'select#zone_difficulty_id', name: 'zone[difficulty_id]'
    end
  end
end
