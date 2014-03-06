require 'spec_helper'

describe 'zones/new' do
  before(:each) do
    assign(:zone, stub_model(Zone,
      name: 'New Zone'
    ).as_new_record)
  end

  it 'renders new zone form' do
    render

    assert_select 'form', action: zones_path, method: 'post' do
      assert_select 'input#zone_name', name: 'zone[name]'
      assert_select 'select#zone_difficulty_id', name: 'zone[difficulty_id]'
    end
  end
end
