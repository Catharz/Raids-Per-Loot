require 'spec_helper'

describe 'instances/edit.html.haml' do
  before(:each) do
    @instance = assign(:instance, stub_model(Instance))
  end

  it 'renders the edit instance form' do
    render

    assert_select 'form', action: instances_path(@instance), method: 'post' do
      assert_select 'select#instance_raid_id', name: 'instance[raid_id]'
      assert_select 'select#instance_zone_id', name: 'instance[zone_id]'
      assert_select 'li#instance_start_time_input.datetime_select'
      assert_select 'select#instance_character_ids',
                    name: 'instance[character_ids][]'
    end
  end
end
