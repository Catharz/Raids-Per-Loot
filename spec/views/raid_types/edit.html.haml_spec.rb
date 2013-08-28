require 'spec_helper'

describe 'raid_types/edit' do
  before(:each) do
    @raid_type = assign(:raid_type, stub_model(RaidType,
                                               name: 'Pickup',
                                               :raid_counted => false,
                                               :raid_points => 1.5,
                                               :loot_counted => true,
                                               :loot_cost => 2.5
    ))
  end

  it 'renders the edit raid_type form' do
    render

    assert_select 'form', action: raid_types_path(@raid_type),
                  method: 'post' do
      assert_select 'input#raid_type_name',
                    name: 'raid_type[name]'
      assert_select 'input#raid_type_raid_counted',
                    name: 'raid_type[raid_counted]'
      assert_select 'input#raid_type_raid_points',
                    name: 'raid_type[raid_points]'
      assert_select 'input#raid_type_loot_counted',
                    name: 'raid_type[loot_counted]'
      assert_select 'input#raid_type_loot_cost',
                    name: 'raid_type[loot_cost]'
    end
  end
end
