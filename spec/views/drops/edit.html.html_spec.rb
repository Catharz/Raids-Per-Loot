require 'spec_helper'

describe 'drops/edit' do
  before(:each) do
    @drop = assign(:drop,
                   stub_model(Drop,
                              zone_id: 1,
                              mob_id: 1,
                              character_id: 1,
                              item_id: 1,
                              item_type_id: 1
                   ))
  end

  it 'renders the edit drop form' do
    render


    assert_select 'form', action: drops_path(@drop), method: 'post' do
      assert_select 'select#drop_zone_id', id: 'drop[zone_id]'
      assert_select 'select#drop_mob_id', id: 'drop[mob_id]'
      assert_select 'select#drop_character_id', id: 'drop[character_id]'
      assert_select 'select#drop_item_id', id: 'drop[item_id]'
      assert_select 'textarea#drop_chat', id: 'drop_chat'
      assert_select 'input#drop_log_line', id: 'drop[log_line]',
                    readonly: 'readonly'
    end
  end
end
