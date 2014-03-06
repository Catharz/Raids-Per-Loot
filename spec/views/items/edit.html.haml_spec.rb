require 'spec_helper'

describe 'items/edit' do

  before(:each) do
    @item = assign(:item, stub_model(Item,
                                     name: 'MyString',
                                     :eq2_item_id => 'MyString',
                                     info_url: 'MyString'
    ))
  end

  it 'renders the edit item form' do
    render


    assert_select 'form', action: items_path(@item), method: 'post' do
      assert_select 'input#item_name', name: 'item[name]'
      assert_select 'input#item_eq2_item_id', name: 'item[eq2_item_id]'
      assert_select 'input#item_info_url', name: 'item[info_url]'
    end
  end
end
