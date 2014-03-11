require 'spec_helper'

describe 'drops/new' do
  before(:each) do
    assign(:drop,
           stub_model(Drop,
                      zone_id: 1,
                      mob_id: 1,
                      character_id: 1,
                      item_id: 1,
                      item_type_id: 1
           ).as_new_record)
  end

  it 'renders new drop form' do
    render

    assert_select 'form', action: drops_path, method: 'post' do
      assert_select 'select#drop_zone_id', id: 'drop[zone_id]'
      assert_select 'select#drop_mob_id', id: 'drop[mob_id]'
      assert_select 'select#drop_character_id', id: 'drop[character_id]'
      assert_select 'select#drop_item_id', id: 'drop[item_id]'
      assert_select 'textarea#drop_chat', id: 'drop_chat'
      assert_select 'input#drop_log_line', id: 'drop[log_line]'
    end
  end
end
